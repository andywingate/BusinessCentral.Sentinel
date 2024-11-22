namespace STM.BusinessCentral.Sentinel;

page 71180275 AlertListSESTM
{
    AdditionalSearchTerms = 'Sentinel';
    ApplicationArea = All;
    Caption = 'Alert List';
    Editable = false;
    PageType = List;
    SourceTable = AlertSESTM;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Id; Rec.Id)
                {
                }
                field("Code"; Rec.AlertCode)
                {
                    StyleExpr = SeverityStyle;
                }
                field("Short Description"; Rec."ShortDescription")
                {

                    trigger OnDrillDown()
                    var
                        IAuditAlert: Interface IAuditAlertSESTM;
                    begin
                        IAuditAlert := Rec.AlertCode;
                        IAuditAlert.ShowMoreDetails();
                    end;
                }
                field(LongDescription; Rec.LongDescription)
                {
                    trigger OnDrillDown()
                    var
                        IAuditAlert: Interface IAuditAlertSESTM;
                    begin
                        IAuditAlert := Rec.AlertCode;
                        IAuditAlert.ShowMoreDetails();
                    end;
                }
                field(Severity; Rec.Severity)
                {
                }
                field("Area"; Rec."Area")
                {
                }
                field(ActionRecommendation; Rec.ActionRecommendation)
                {
                    trigger OnDrillDown()
                    var
                        IAuditAlert: Interface IAuditAlertSESTM;
                    begin
                        IAuditAlert := Rec.AlertCode;
                        IAuditAlert.RunActionRecommendations();
                    end;
                }
                field(Ignore; Rec.Ignore)
                {
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunAnalysis)
            {
                Caption = 'Run Analysis';
                Image = Suggest;
                ToolTip = 'Run the analysis of the current environment, and check for new alerts.';

                trigger OnAction()
                begin
                    Rec.RunAllAlerts();
                end;
            }
        }
        area(Promoted)
        {
            actionref(RunAnalysis_Promoted; RunAnalysis) { }
        }
    }

    var
        SeverityStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Severity of
            SeveritySESTM::Info:
                SeverityStyle := Format(PageStyle::StandardAccent);
            SeveritySESTM::Warning:
                SeverityStyle := Format(PageStyle::Ambiguous);
            SeveritySESTM::Error:
                SeverityStyle := Format(PageStyle::Attention);
            SeveritySESTM::Critical:
                SeverityStyle := Format(PageStyle::Unfavorable);
        end;
    end;

}