import SwiftUI

/// A reading plan: a run of books split evenly over a number of days.
struct Plan: Identifiable {
    let id: String
    let name: String
    let books: Range<Int>
    let days: Int

    static let all = [
        Plan(id: "gospels", name: "The Gospels in 30 days", books: 39..<43, days: 30),
        Plan(id: "psalms", name: "Psalms in 30 days", books: 18..<19, days: 30),
        Plan(id: "nt", name: "New Testament in 90 days", books: 39..<66, days: 90),
        Plan(id: "year", name: "The whole Bible in a year", books: 0..<66, days: 365),
    ]

    static func find(_ id: String) -> Plan? { all.first { $0.id == id } }

    func chapters(_ bible: Bible = .shared) -> [Place] {
        books.flatMap { b in bible.books[b].chapters.indices.map { Place(book: b, chapter: $0 + 1) } }
    }

    /// The chapters for day `d` (0 based). Every chapter lands on exactly one day.
    func day(_ d: Int, _ bible: Bible = .shared) -> [Place] {
        let all = chapters(bible)
        return Array(all[d * all.count / days ..< (d + 1) * all.count / days])
    }
}

/// The plan card on Today: start a plan, read the next day's chapters, check it off.
struct PlanCard: View {
    let read: (Place) -> Void
    @AppStorage("plan") private var planID = ""
    @AppStorage("planDone") private var doneList = ""
    private let bible = Bible.shared

    private var done: Set<Int> { Set(doneList.split(separator: ",").compactMap { Int($0) }) }

    var body: some View {
        if let plan = Plan.find(planID) {
            let done = done
            let next = (0..<plan.days).first { !done.contains($0) }
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text(plan.name).font(.headline)
                    Spacer()
                    Menu { Button("End Plan", role: .destructive) { planID = ""; doneList = "" } } label: {
                        Image(systemName: "ellipsis.circle").foregroundStyle(.secondary)
                    }
                    .accessibilityLabel("Plan options")
                }
                ProgressView(value: Double(done.count), total: Double(plan.days)).tint(Theme.button)
                if let d = next {
                    Text("Day \(d + 1) of \(plan.days)").font(.subheadline).foregroundStyle(Theme.secondary)
                    FlowChapters(places: plan.day(d), read: read)
                    Button { doneList = (done.union([d])).sorted().map(String.init).joined(separator: ",") } label: {
                        Label("Mark Day \(d + 1) Read", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent).tint(Theme.button).controlSize(.large)
                } else {
                    Text("Finished. Every chapter read.").font(.subheadline).foregroundStyle(Theme.secondary)
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 16) {
                Text("Read a little each day and keep your place.").foregroundStyle(Theme.secondary)
                Menu {
                    ForEach(Plan.all) { p in Button(p.name) { planID = p.id; doneList = "" } }
                } label: { Label("Start a Plan", systemImage: "calendar") }
                .buttonStyle(.borderedProminent).tint(Theme.button).controlSize(.large)
            }
        }
    }
}

/// The day's chapters as tappable capsules.
private struct FlowChapters: View {
    let places: [Place]
    let read: (Place) -> Void
    private let bible = Bible.shared

    var body: some View {
        Flow {
            ForEach(places, id: \.self) { p in
                Button(bible.title(p)) { read(p) }.buttonStyle(.bordered).lineLimit(1)
            }
        }
    }
}

/// Lays children left to right and wraps to a new line when the row is full.
private struct Flow: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = place(subviews, width: proposal.width ?? .infinity)
        return CGSize(width: proposal.width ?? rows.map(\.maxX).max() ?? 0, height: rows.last.map { $0.maxY } ?? 0)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        for (frame, view) in zip(place(subviews, width: bounds.width), subviews) {
            view.place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: ProposedViewSize(frame.size))
        }
    }

    private func place(_ subviews: Subviews, width: CGFloat) -> [CGRect] {
        var x: CGFloat = 0, y: CGFloat = 0, row: CGFloat = 0
        return subviews.map { v in
            let s = v.sizeThatFits(.unspecified)
            if x > 0 && x + s.width > width { x = 0; y += row + spacing; row = 0 }
            defer { x += s.width + spacing; row = max(row, s.height) }
            return CGRect(origin: CGPoint(x: x, y: y), size: s)
        }
    }
}
