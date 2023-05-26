##  git log -1 --pretty=format:"%h,%cn,%cI,%s"
Write-Output 'Executing ...'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add('http://+:8080/')
$listener.Start()
$StopListener = $false

while ($listener.IsListening) {
    Write-Output 'Inside Listener loop ... '
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $QueryData = @{}
    foreach ($key in $request.QueryString.AllKeys) {
        $QueryData.Add($key, $request.QueryString[$key])
        Write-Output "$key : $($request.QueryString[$key])"
        if (($key -eq 'End') -and ($request.QueryString[$key] -eq 'true')) {
            Write-Output 'Entering $listener.Stop() aka "safe" exiting path ...'
            $StopListener = $true        
        }
        if (($key -eq 'ExitError') -and ($request.QueryString[$key] -eq 'true')) {
            Write-Output 'Entering the bad exiting path ...'
            throw 'Bad stuff must be happening'     
        }
    }
    $JsonOutput = $QueryData | ConvertTo-Json -Depth 5

    $response.ContentType = 'application/json'
    $response.StatusCode = 200
    $response.StatusDescription = 'OK'
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($JsonOutput)
    $response.ContentLength64 = $buffer.Length
    $output = $response.OutputStream
    $output.Write($buffer, 0, $buffer.Length)
    $output.Close()
    if ($StopListener) {
        $listener.Stop()
    }
}


