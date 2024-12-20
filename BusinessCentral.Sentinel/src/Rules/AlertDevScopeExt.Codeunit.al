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
        ActionRecommendationLbl: Label 'Talk to the third party that developed the extension and ask them to publish the extension in PTE scope instead.';
        LongDescLbl: Label 'Extension in DEV Scope will get uninstalled when the environment is upgraded to a newer version. Publishing them in PTE scope instead will prevent this.';
        ShortDescLbl: Label 'Extension in DEV Scope found: %1', Comment = '%1 = Extension Name';
    begin
        Extensions.SetRange("Published As", Extensions."Published As"::Dev);
        Extensions.ReadIsolation(IsolationLevel::ReadUncommitted);
        Extensions.SetLoadFields("App ID", Name);
        if Extensions.FindSet() then
            repeat
                Alert.SetRange(AlertCode, "AlertCodeSESTM"::"SE-000002");
                Alert.SetRange("UniqueIdentifier", Extensions."App ID");
                if Alert.IsEmpty() then begin
                    Alert.Validate(AlertCode, "AlertCodeSESTM"::"SE-000002");
                    Alert.Validate("ShortDescription", StrSubstNo(ShortDescLbl, Extensions."Name"));
                    Alert.Validate(Severity, SeveritySESTM::Warning);
                    Alert.Validate("Area", AreaSESTM::Technical);
                    Alert.Validate(LongDescription, LongDescLbl);
                    Alert.Validate(ActionRecommendation, ActionRecommendationLbl);
                    Alert.Validate(UniqueIdentifier, Extensions."App ID");
                    Alert.Insert(true);
                end;
            until Extensions.Next() = 0;
    end;

    procedure ShowMoreDetails(var Alert: Record AlertSESTM)
    var
        DetailedExplanationMsg: Label 'Extensions published in DEV scope will get uninstalled when the environment is upgraded to a newer version. Publishing them in PTE scope instead will prevent this.\\This is also an indicator that the developer of this extension may not be using a repository with automated deployment. You may want to investigate here to find out about the reasons for this extension being published in DEV scope.';
    begin
        Message(DetailedExplanationMsg);
    end;

    procedure RunActionRecommendations(var Alert: Record AlertSESTM)
    var
        OpenPageQst: Label 'Do you want to open the page to manage the extension?';
    begin
        if Confirm(OpenPageQst) then
            Page.Run(Page::"Extension Management");
    end;
}