namespace STM.BusinessCentral.Sentinel;

using STM.BusinessCentral.Sentinel;
using System.Apps;
using System.Utilities;

codeunit 71180277 AlertDevScopeExtSESTM implements IAuditAlertSESTM
{
    Access = Public;
    Permissions =
        tabledata AlertSESTM = RI,
        tabledata "NAV App Installed App" = R;

    procedure CreateAlerts()
    var
        Alert: Record AlertSESTM;
        Extensions: Record "NAV App Installed App";
    begin
        Extensions.SetRange("Published As", Extensions."Published As"::Dev);
        Extensions.ReadIsolation(IsolationLevel::ReadUncommitted);
        if Extensions.FindSet() then
            repeat
                Alert.SetRange(AlertCode, "AlertCodeSESTM"::"SE-000002");
                Alert.SetRange("UniqueIdentifier", Extensions."App ID");
                if Alert.IsEmpty() then begin
                    Alert.AlertCode := "AlertCodeSESTM"::"SE-000002";
                    Alert."ShortDescription" := StrSubstNo('Extension in DEV Scope found: %1', Extensions."Name");
                    Alert.Severity := SeveritySESTM::Warning;
                    Alert."Area" := AreaSESTM::Technical;
                    Alert.LongDescription := 'Extension in DEV Scope will get uninstalled when the environment is upgraded to a newer version. Publishing them in PTE scope instead will prevent this.';
                    Alert.UniqueIdentifier := Extensions."App ID";
                    Alert.Insert(true);
                end;
            until Extensions.Next() = 0;
    end;

    procedure ShowMoreDetails()
    begin

    end;

    procedure RunActionRecommendations()
    begin

    end;
}