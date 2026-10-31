# Security

## Reporting

Found something? Email **trommatic@icloud.com**. Don't open a public issue for anything exploitable.

You'll hear back within a week. This is a solo side project. No bounty, no SLA, just a reply.

## Supported versions

The deployed version and the tip of `main`. Nothing else.

## What keeps you safe

Bible keeps no account, no cookie and no analytics. The page is static. It stores nothing and runs no server code of its own.

The passage you type goes to BibleGateway inside a frame, the same as opening their site. The frame address is built with `encodeURIComponent`, so a passage cannot change the host or add parameters. Nothing from the frame is read back, and the page loads scripts from its own address only.
