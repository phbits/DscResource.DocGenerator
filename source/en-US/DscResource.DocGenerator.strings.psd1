# English strings
ConvertFrom-StringData @'
    FoundMofFilesMessage                 = Found {0} MOF files in path '{1}'.
    GenerateHelpDocumentMessage          = Generating help document for '{0}'.
    OutputHelpDocumentMessage            = Outputting help document to '{0}'.
    GenerateWikiPageMessage              = Generating wiki page for '{0}'.
    OutputWikiPageMessage                = Outputting wiki page to '{0}'.
    NoDescriptionFileFoundWarning        = No README.md description file found for '{0}', skipping.
    MultipleDescriptionFileFoundWarning  = {1} README.md description files found for '{0}', skipping.
    NoExampleFileFoundWarning            = No Example files found.
    CreateTempDirMessage                 = Creating a temporary working directory.
    ConfigGlobalGitMessage               = Configuring global Git settings.
    ConfigLocalGitMessage                = Configuring local Git settings.
    CloneWikiGitRepoMessage              = Cloning the Wiki Git Repository '{0}'.
    AddWikiContentToGitRepoMessage       = Adding the Wiki Content to the Git Repository.
    CommitAndTagRepoChangesMessage       = Committing the changes to the Repository and adding build tag '{0}'.
    PushUpdatedRepoMessage               = Pushing the updated Repository to the Git Wiki.
    PublishWikiContentCompleteMessage    = Publish Wiki Content complete.
    UpdateWikiCommitMessage              = Updating Wiki with the content for module version '{0}'.
    NewTempFolderCreationError           = Unable to create a temporary working folder in '{0}'.
    InvokingGitMessage                   = Invoking Git '{0}'.
    GenerateWikiSidebarMessage           = Generating Wiki Sidebar '{0}'.
    GenerateWikiFooterMessage            = Generating Wiki Footer '{0}'.
    CopyWikiFoldersMessage               = Copying Wiki files from '{0}'.
    CopyFileMessage                      = Copying file '{0}' to the Wiki.
    AddFileToSideBar                     = Adding file '{0}' to the Wiki Sidebar.
    NothingToCommitToWiki                = There are no changes to the documentation to commit and push to the Wiki.
    FoundClassBasedMessage               = Found {0} class-based resources in the built module '{1}'.
    FoundClassResourcePropertyMessage    = Found property '{0}' in the resource '{1}'.
    CommentBasedHelpMessage              = Reading comment-based help from source file '{0}'.
    FoundResourceExamplesMessage         = Found {0} examples.
    IgnoreAstParseErrorMessage           = Errors was found during parsing of comment-based help. These errors were ignored: {0}
    WikiGitCloneFailMessage              = Failed to clone wiki. Ensure the feature is enabled and the first page has been created.
    WikiGitCloneFailMessageDebug         = Wiki clone URL '{0}'
    InvokeGitStandardOutputMessage       = git standard output: '{0}'
    InvokeGitStandardErrorMessage        = git standard error: '{0}'
    InvokeGitExitCodeMessage             = git exit code: '{0}'
    FoundCompositeFilesMessage           = Found {0} composite files in path '{1}'.
    CommentBasedHelpBlockNotFound        = A comment-based help block in source file '{0}' could not be found.
    CommentBasedHelpBlockNotAtTopMessage = A comment-based help block in source file '{0}' was found, but is not at the top of the file.
    CompositeResourceMultiConfigError    = {1} composite resources were found in the source file '{0}'. This is not currently supported. Please separate these into different scripts.
    MacOSNotSupportedError               = NotImplemented: MacOS is not supported for this operation because DSC can not be installed onto it. Please use an OS that DSC can be installed onto.
'@
