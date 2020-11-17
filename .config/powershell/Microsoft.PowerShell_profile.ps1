Import-Module Az.Tools.Predictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView

function azc {
    $allContexts = (Get-AzContext -List | Sort-Object Account)
    $contextArray = @()
    $contextEmailArray = @()
    $contextCount = 0

    Write-Host ""
    Foreach ($context in $allContexts) {
        if (!$contextEmailArray.Contains($context.Account.Id)) {
            $contextArray += $context
            $contextEmailArray += $context.Account.Id
            Write-Host ("[" + $contextCount + "] - " + $context.Account)
            $contextCount++
        }
    }

    if (!($contextInput = Read-Host "Select Context")) { $contextInput = 0 }
    Set-AzContext -Context $contextArray[$contextInput]

    $allSubscriptions = (Get-AzSubscription | Where-Object { $_.State -eq "Enabled" } | Sort-Object Name)
    $subscriptionArray = @()
    $subscriptionCount = 0

    foreach ($subscription in $allSubscriptions) {
        $subscriptionArray += $subscription.Id
        Write-Host ("[" + $subscriptionCount + "] - " + $subscription.Name + " - " + $subscription.Id)
        $subscriptionCount++
    }

    if ($subscriptionArray.Count -gt 1) {
        if (!($subscriptionInput = Read-Host "Select Subscription")) { $subscriptionInput = 0 }
    }
    else {
        $subscriptionInput = 0
    }
    
    Set-AzContext -SubscriptionId $subscriptionArray[$subscriptionInput]
}
