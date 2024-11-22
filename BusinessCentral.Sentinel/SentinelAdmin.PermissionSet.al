namespace STM.BusinessCentral.Sentinel;

using STM.BusinessCentral.Sentinel;

permissionset 71180275 SentinelAdminSESTM
{
    Assignable = true;
    Permissions = table AlertSESTM = X,
        tabledata AlertSESTM = RIMD,
        table IgnoredAlertsSESTM = X,
        tabledata IgnoredAlertsSESTM = RIMD,
        codeunit AlertDevScopeExtSESTM = X,
        codeunit AlertPteDownloadCodeSESTM = X,
        codeunit AlertSESTM = X,
        page AlertListSESTM = X;
}