namespace STM.BusinessCentral.Sentinel;

using STM.BusinessCentral.Sentinel;

table 71180275 AlertSESTM
{
    Access = Public;
    Caption = 'Alert';
    DataClassification = SystemMetadata;
    DrillDownPageId = AlertListSESTM;
    Extensible = false;
    LookupPageId = AlertListSESTM;

    fields
    {
        field(1; Id; BigInteger)
        {
            Caption = 'ID';
            NotBlank = true;
        }
        field(2; AlertCode; Enum "AlertCodeSESTM")
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(3; ShortDescription; Text[100])
        {
            Caption = 'Short Description';
        }
        field(4; LongDescription; Text[250])
        {
            Caption = 'Long Description';
        }
        field(5; Severity; Enum SeveritySESTM)
        {
            Caption = 'Severity';
        }
        field(6; ActionRecommendation; Text[250])
        {
            Caption = 'Action Recommendation';
        }
        field(7; "Area"; Enum AreaSESTM)
        {
            Caption = 'Area';
        }
        field(8; UniqueIdentifier; Text[100])
        {
            // This is the unique Guid for a specific warning, not a an ID for the Alert Code
            // Its used to allow the user to mark a warning as read
            Caption = 'Unique Identifier';
        }
        field(9; Ignore; Boolean)
        {
            Caption = 'Ignore';
        }
    }

    keys
    {
        key(PK; Id)
        {
            Clustered = true;
        }
        key(UniqueId; AlertCode, UniqueIdentifier) { }
    }

    trigger OnInsert()
    begin
        if not NumberSequence.Exists('BCSentinelSESTMAlertId') then
            NumberSequence.Insert('BCSentinelSESTMAlertId');

        Rec.Id := NumberSequence.Next('BCSentinelSESTMAlertId');
    end;

    local procedure EnumLoop()
    var
        AlertCodes: Enum AlertCodeSESTM;
        currOrdinal: Integer;
    begin
        foreach currOrdinal in Enum::AlertCodeSESTM.Ordinals() do begin
            AlertCodes := Enum::AlertCodeSESTM.FromInteger(currOrdinal);
            //do something here
        end;
    end;

    procedure RunAllAlerts()
    var
        currOrdinal: Integer;
        Alert: Interface IAuditAlertSESTM;
        AlertsToRun: List of [Interface IAuditAlertSESTM];
    begin
        foreach currOrdinal in Enum::AlertCodeSESTM.Ordinals() do
            AlertsToRun.Add(Enum::AlertCodeSESTM.FromInteger(currOrdinal));

        // TODO: add event to allow other extensions to add Alerts

        foreach Alert in AlertsToRun do
            Alert.CreateAlerts();
    end;
}