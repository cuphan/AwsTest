def commitID() {
    sh 'git rev-parse --short=10 HEAD > .git/commitID'
    def commitID = readFile('.git/commitID').trim()
    sh 'rm .git/commitID'
    commitID
}

return this