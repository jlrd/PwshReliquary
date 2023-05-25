##  git log -1 --pretty=format:"%h,%cn,%cI,%s"

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
$StopListener = $false

while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response

    $QueryData = @{}
    foreach ($key in $request.QueryString.AllKeys) {
        $QueryData.Add($key, $request.QueryString[$key])

        if (($key -eq "end") -and ($request.QueryString[$key] -eq "true")) {
            $StopListener = $true        
        }
    }
    $JsonOutput = $QueryData | ConvertTo-Json -Depth 5

    $response.ContentType = "application/json"
    $response.StatusCode = 200
    $response.StatusDescription = "OK"
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($JsonOutput)
    $response.ContentLength64 = $buffer.Length
    $output = $response.OutputStream
    $output.Write($buffer, 0, $buffer.Length)
    $output.Close()
    if ($StopListener) {
        $listener.Stop()
    }
}


