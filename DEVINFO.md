
# Tags
Tags are used to clearly identify releases, commits that warrant a
major or minor version bump, and other commits where an associated
name is important.

Versioning is done via tagging so there are some firm rules around
naming of tags.

## Release Tags
Release tags are named `v#.#.#` where `#.#.#` conforms to semantic
versioning.  Release tags are annotated tags.  When a commit is
directly pointed to by a `vMAJOR.MINOR.PATCH` tag then it is the
release version `MAJOR.MINOR.PATCH`

If a release tag is the most recent tag reachable from a commit but
the tag does not point to the commit then the version is
`MAJOR.MINOR.(PATCH+1)pre-##-ID[-dirty]` where `##` is the number of
commits past the tag, `ID` is the commit ID, and `-dirty` is appended
if the worktree is dirty.  See `git help describe` for more details
about how the tag name is found.

## Development Tags
Commits past a release tag must only be changes that would result
in a patch release.  For changes that would result in a major or
minor version change, create a development tag.  A development
tag has the form `devMAJOR.MINOR.PATCH` where `MAJOR` and `MINOR`
correspond to what would be the next release and `PATCH` should be
0 because we always reset the patch portion of a semantic version
when bumping the major or minor verion.

# Release Notes

# Future Considerations
Consider using
https://github.com/mikemiles86/semtag-generator


