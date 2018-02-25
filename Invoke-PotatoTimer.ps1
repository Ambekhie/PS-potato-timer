# Script Potato-Timer
<# 
.SYNOPSIS
	 Cool Potato-Timer Script 
.DESCRIPTION
	 It's used to estimate your assigned tasks time
.NOTES
	 Author     : Amr Bekhiet - t-ambekh@microsoft.com
.LINK
	 https://github.com/Btatsaya/PS-potato-timer
#>

Function Go-Sleep ($targetTime)
{
	$percisionInSeconds = 1
	do 
	{
		Start-Sleep $percisionInSeconds
	}
	until ((get-date) -ge ($targetTime))
}

Function Invoke-PotatoTip ($messageType, $title, $message, $duration)
{
	if (-Not $global:potatoTip)
	{
		$global:potatoTip = New-Object System.Windows.Forms.NotifyIcon

		#Mouse double click on icon to dispose
		[void](Register-ObjectEvent -InputObject $potatoTip -EventName MouseDoubleClick -SourceIdentifier IconClicked -Action {
			#Perform cleanup actions on potato tip
			Write-Verbose 'Disposing of potato tip'
			$global:potatoTip.dispose()
			Unregister-Event -SourceIdentifier IconClicked
			Remove-Job -Name IconClicked
			Remove-Variable -Name potatoTip -Scope Global
		})
	}

	#Can only use certain TipIcons: [System.Windows.Forms.ToolTipIcon] | Get-Member -Static -Type Property
	$global:potatoTip.BalloonTipIcon  = [System.Windows.Forms.ToolTipIcon]::Info
	$global:potatoTip.BalloonTipTitle = $title
	$global:potatoTip.Visible = $true

	#Display the tip and specify in milliseconds on how long potatoTip will stay visible
	$global:potatoTip.BalloonTipText  = $message
	$global:potatoTip.ShowBalloonTip($duration)
}

Function Invoke-PotatoTimer
{
	$duration = 1000
	$message = 'Go!'
	$messageType = 'Info'
	$title = 'Potato-Timer'
	$orderOfPotatoUnit = 4
	$potatoUnit = $(New-TimeSpan -Minutes 15)
	Invoke-PotatoTip $messageType $title $message $duration
	for ($unit = 0; $unit -lt $orderOfPotatoUnit; $unit++)
	{
		Go-Sleep ((Get-Date) + $potatoUnit)
		switch ( $unit )
		{
			0 { $message = 'Quarter Potato' }
			1 { $message = 'Half Potato' }
			2 { $message = 'Three Quarter Potato' }
			3 { $message = 'One potato' }
		}
		
		Invoke-PotatoTip $messageType $title $message $duration
	}
}

Add-Type -AssemblyName  System.Windows.Forms

#Invoke-Timer
Invoke-PotatoTimer
