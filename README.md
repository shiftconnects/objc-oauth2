# OAuth2 in Objective-C

## Goals
OAuth2 implements only a fraction of RFC 6749. It’s designed to handle [Resource Owner Password Credentials Grant](https://tools.ietf.org/html/rfc6749#section-4.3) only.

## Quick setup
- Build *Universal* target, you’ll find a copy of ```OAuth2.framework``` in the project directory.
- Copy ```OAuth2.framework``` to your project. Make sure to add it to **Embedded Binaries** section of the project.

## Patterns
- Store ```SFTToken``` object between sessions, ```SFTOAuth``` will update it as necessary with refresh tokens and expiration dates.

## Further reading
- [https://tools.ietf.org/html/rfc6749](https://tools.ietf.org/html/rfc6749)