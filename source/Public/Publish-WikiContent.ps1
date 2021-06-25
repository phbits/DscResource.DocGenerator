<#
    .SYNOPSIS
        Publishes the Wiki Content that is generated by New-DscResourceWikiPage.

    .DESCRIPTION
        This function publishes the content pages from the Wiki Content that is
        generated by New-DscResourceWikiPage along with any additional files
        stored in the 'WikiSource' directory of the repository and an auto-generated
        sidebar file containing links to all the markdown files to the Wiki of a
        specified GitHub repository.

    .PARAMETER Path
        The path to the output that was generated by New-DscResourceWikiPage.

    .PARAMETER OwnerName
        The owner name of the Github repository.

    .PARAMETER RepositoryName
        The name of the Github repository.

    .PARAMETER ModuleName
        The name of the Dsc Resource Module.

    .PARAMETER ModuleVersion
        The build version number to tag the Wiki Github commit with.

    .PARAMETER GitHubAccessToken
        The GitHub access token to allow a push to the GitHub Wiki.

    .PARAMETER GitUserEmail
        The email address to use for the Git commit.

    .PARAMETER GitUserName
        The user name to use for the Git commit.

    .PARAMETER GlobalCoreAutoCrLf
        Specifies how line breaks should be handled when cloning the
        GitHub wiki repository. Valid values are 'true', 'false', or
        'input'.

    .EXAMPLE
        Publish-WikiContent `
            -Path '.\output\WikiContent' `
            -OwnerName 'dsccommunity' `
            -RepositoryName 'SqlServerDsc' `
            -ModuleName 'SqlServerDsc' `
            -ModuleVersion '14.0.0' `
            -GitHubAccessToken 'token' `
            -GitUserEmail 'email@contoso.com' `
            -GitUserName 'dsc' `
            -WikiSourcePath '.\source\WikiSource'

        Adds the content pages in '.\output\WikiContent' to the Wiki for the
        specified GitHub repository.
#>
function Publish-WikiContent
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Path,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OwnerName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $RepositoryName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ModuleName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ModuleVersion,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GitHubAccessToken,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GitUserEmail,

        [Parameter(Mandatory = $true)]
        [System.String]
        $GitUserName,

        [Parameter()]
        [ValidateSet('true', 'false', 'input')]
        [System.String]
        $GlobalCoreAutoCrLf
    )

    $ErrorActionPreference = 'Stop'

    Write-Verbose -Message $script:localizedData.CreateTempDirMessage

    $tempPath = New-TempFolder
    $wikiRepoName = "https://github.com/$OwnerName/$RepositoryName.wiki.git"

    try
    {
        Write-Verbose -Message $script:localizedData.ConfigGlobalGitMessage

        if ($PSBoundParameters.ContainsKey('GlobalCoreAutoCrLf'))
        {
            $null = Invoke-Git -WorkingDirectory $tempPath.FullName `
                        -Arguments @( 'config', '--global', 'core.autocrlf', $GlobalCoreAutoCrLf )
        }

        Write-Verbose -Message ($script:localizedData.CloneWikiGitRepoMessage -f $WikiRepoName)

        $gitCloneResult = Invoke-Git -WorkingDirectory $tempPath.FullName `
                            -Arguments @( 'clone', $wikiRepoName, $tempPath, '--quiet' )

        if ($gitCloneResult.ExitCode -eq 0)
        {
            $copyWikiFileParameters = @{
                Path            = $Path
                DestinationPath = $tempPath
                Force           = $true
            }

            Copy-WikiFolder @copyWikiFileParameters

            New-WikiSidebar -ModuleName $ModuleName -Path $tempPath
            New-WikiFooter -Path $tempPath

            Set-Location -Path $tempPath

            Write-Verbose -Message $script:localizedData.ConfigLocalGitMessage

            $null = Invoke-Git -WorkingDirectory $tempPath.FullName `
                        -Arguments @( 'config', '--local', 'user.email', $GitUserEmail )

            $null = Invoke-Git -WorkingDirectory $tempPath.FullName `
                        -Arguments @( 'config', '--local', 'user.name', $GitUserName )

            $null = Invoke-Git -WorkingDirectory $tempPath.FullName `
                        -Arguments @( 'remote', 'set-url', 'origin', "https://$($GitUserName):$($GitHubAccessToken)@github.com/$OwnerName/$RepositoryName.wiki.git" )

            Write-Verbose -Message $localizedData.AddWikiContentToGitRepoMessage

            $null = Invoke-Git -WorkingDirectory $tempPath.FullName `
                        -Arguments @( 'add', '*' )

            Write-Verbose -Message ($localizedData.CommitAndTagRepoChangesMessage -f $ModuleVersion)

            $gitCommitResult = Invoke-Git -WorkingDirectory $tempPath.FullName `
                                    -Arguments @( 'commit', '--message', "`"$($localizedData.UpdateWikiCommitMessage -f $ModuleVersion)`"", '--quiet' )

            if ($gitCommitResult.ExitCode -eq 0)
            {
                $null = Invoke-Git -WorkingDirectory $tempPath.FullName `
                            -Arguments @( 'tag', '--annotate', $ModuleVersion, '--message', $ModuleVersion )

                Write-Verbose -Message $localizedData.PushUpdatedRepoMessage

                $null = Invoke-Git -WorkingDirectory $tempPath.FullName `
                            -Arguments @( 'push', 'origin', '--quiet' )

                $null = Invoke-Git -WorkingDirectory $tempPath.FullName `
                            -Arguments @( 'push', 'origin', $ModuleVersion, '--quiet' )

                Write-Verbose -Message $localizedData.PublishWikiContentCompleteMessage
            }
            else
            {
                Write-Warning -Message $localizedData.NothingToCommitToWiki
            }
        }
        else
        {
            Write-Verbose -Message $script:localizedData.WikiGitCloneFailMessage

            Write-Debug -Message ($script:localizedData.WikiGitCloneFailMessageDebug -f $wikiRepoName)
            Write-Debug -Message ($script:localizedData.InvokeGitStandardOutput -f $gitCloneResult.StandardOutput)
            Write-Debug -Message ($script:localizedData.InvokeGitStandardError -f $gitCloneResult.StandardError)
            Write-Debug -Message ($script:localizedData.InvokeGitExitCodeMessage -f $gitCloneResult.ExitCode)
        }
    }
    finally
    {
        Remove-Item -Path $tempPath -Recurse -Force
    }
}
