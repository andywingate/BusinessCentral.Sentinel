namespace STM.BusinessCentral.Sentinel;

using STM.BusinessCentral.Sentinel;
using System.Apps;
using System.Utilities;

codeunit 71180276 AlertPteDownloadCodeSESTM implements IAuditAlertSESTM
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
        Extensions.SetRange("Published As", Extensions."Published As"::PTE);
        Extensions.ReadIsolation(IsolationLevel::ReadUncommitted);
        if Extensions.FindSet() then
            repeat
                Alert.SetRange(AlertCode, "AlertCodeSESTM"::"SE-000001");
                Alert.SetRange("UniqueIdentifier", Extensions."App ID");
                if Alert.IsEmpty() then
                    if not this.CanDownloadSourceCode(Extensions."Package ID") then begin
                        Alert.AlertCode := "AlertCodeSESTM"::"SE-000001";
                        Alert."ShortDescription" := StrSubstNo('Per Tenant Extension "%1" does not allow Download Code', Extensions."Name");
                        Alert.Severity := SeveritySESTM::Warning;
                        Alert."Area" := AreaSESTM::Technical;
                        Alert.LongDescription := 'Per Tenant Extension does not allow Download Code, if the code was developed for you by a third party, you might want to make sure to have access to the code in case you need to make changes in the future and the third party is not available anymore.';
                        Alert.UniqueIdentifier := Extensions."App ID";
                        Alert.Insert(true);
                    end;
            until Extensions.Next() = 0;
    end;

    [TryFunction]
    local procedure CanDownloadSourceCode(PackageId: Guid)
    var
        ExtensionManagement: Codeunit "Extension Management";
        ExtensionSourceTempBlob: Codeunit "Temp Blob";
    begin
        ExtensionManagement.GetExtensionSource(PackageId, ExtensionSourceTempBlob);
    end;

    procedure ShowMoreDetails()
    begin

    end;

    procedure RunActionRecommendations()
    begin

    end;
}