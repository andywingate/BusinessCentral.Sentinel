namespace STM.BusinessCentral.Sentinel;

enum 71180275 "AlertCodeSESTM" implements IAuditAlertSESTM
{
    Access = Public;
    DefaultImplementation = IAuditAlertSESTM = AlertSESTM;
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ', Locked = true;
    }
    value(1; "SE-000001")
    {
        // Warns if Per Tenant Extension do not allow Download Code
        Caption = 'SE-000001';
        Implementation = IAuditAlertSESTM = AlertPteDownloadCodeSESTM;
    }
    value(2; "SE-000002")
    {
        // Warns if Extension in DEV Scope are installed
        Caption = 'SE-000002';
        Implementation = IAuditAlertSESTM = AlertDevScopeExtSESTM;
    }
}