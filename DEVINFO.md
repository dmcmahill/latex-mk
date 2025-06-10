# Release Builds
To streamline the release system, the project has moved to using
github actions both for CI checks during development as well as building
releases and pre-release snapshots.

# Tags
Tags are used to clearly identify releases, commits that warrant a
major or minor version bump, and other commits where an associated
name is important.

Versioning is done via tagging so there are some firm rules around
naming of tags.

## Release Tags
Release tags are named `v#.#.#` where `#.#.#` conforms to semantic
versioning.  See [https://semver.org/] for details about semantic
versioning.

Release tags are annotated tags.  When a commit is
directly pointed to by a `vMAJOR.MINOR.PATCH` tag then it is the
release version `MAJOR.MINOR.PATCH`.  For example a tag called
`v1.2.3` is the version 1.2.3 release.

If a release tag is the most recent tag reachable from a commit but
the tag does not point to the commit then the version is
`MAJOR.MINOR.(PATCH+1)pre-##-ID[-dirty]` where `##` is the number of
commits past the tag, `ID` is the commit ID, and `-dirty` is appended
if the worktree is dirty.  See `git help describe` for more details
about how the tag name is found.  As an example, if there are 5
commits past the `v1.2.3` release tag and the worktree is clean
(i.e. no outstanding uncommitted changes), then the version would
be 1.2.4pre-5-abcd1234 (assuming that `abcd1234` is the commit ID
of the head).  This indicates that we are working towards a
version 1.2.4 patch release.


## Development Tags
Commits past a release tag must only contain changes that would result
in a patch release.  For changes that would result in a major or
minor version change, create a development tag.  A development
tag has the form `devMAJOR.MINOR.PATCH` where `MAJOR` and `MINOR`
correspond to what would be the next release and `PATCH` should be
0 because we always reset the patch portion of a semantic version
when bumping the major or minor verion.

As an example, suppose the previous release was version 1.2.3.
Development is proceeding making backwards compatible bug fixes.
During this phase, the reported version would be 1.2.4pre-#-#######.
Now we decide to add some functionality in a backwards compatible
manner.  According to semantic versioning rules this warrants a
minor version bump.  A development tag with the name `dev1.3.0`
should be created.  At this point the reported version will
be `1.3.0pre-#-#######` because we are working towards a version
`1.3.0` release.

Similarly if we make an incompatible API change then a major version
bump is indicated and we would create a new development tag named
`dev2.0.0` and the reported version will be `2.0.0pre-#-########`
to indicate that we are working towards a version `2.0.0` release.

# Release Notes
Before a release, the `NEWS` file should be updated with a summary
of importan changes.

# Future Considerations
Consider using
https://github.com/mikemiles86/semtag-generator


