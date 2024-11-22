namespace STM.BusinessCentral.Sentinel;

using STM.BusinessCentral.Sentinel;

permissionset 71180275 SentinelAdminSESTM
{
    Assignable = true;
    Permissions = table AlertSESTM = X,
        tabledata AlertSESTM = RIMD,
        codeunit AlertPteDownloadCodeSESTM = X,
        codeunit AlertSESTM = X,
        page AlertListSESTM = X;
}