Task Default -depends Build

Task Build {
    Exec { docker build --tag=pwshreliquary . }
}