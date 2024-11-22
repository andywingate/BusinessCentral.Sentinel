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
                    MultiLine = true;

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
                    Rec.FindNewAlerts();
                end;
            }
            action(SetToIgnore)
            {
                Caption = 'Ignore';
                Image = Delete;
                ToolTip = 'Ignore this alert.';

                trigger OnAction()
                begin
                    Rec.SetToIgnore();
                end;
            }
            action(ClearIgnore)
            {
                Caption = 'Stop Ignoring';
                Image = Restore;
                ToolTip = 'Clear the ignore status of this alert.';

                trigger OnAction()
                begin
                    Rec.ClearIgnore();
                end;
            }
            action(ClearAllAlerts)
            {
                Caption = 'Clear All Alerts';
                Image = Delete;
                ToolTip = 'Clear all alerts.';

                trigger OnAction()
                begin
                    Rec.ClearAllAlerts();
                end;
            }
            action(FullReRun)
            {
                Caption = 'Full Re-Run';
                Image = Suggest;
                ToolTip = 'Run the analysis of the current environment, and check for new alerts.';

                trigger OnAction()
                begin
                    Rec.FullRerun();
                end;
            }
        }
        area(Promoted)
        {
            actionref(RunAnalysis_Promoted; RunAnalysis) { }
            actionref(SetToIgnore_Promoted; SetToIgnore) { }
            actionref(ClearIgnore_Promoted; ClearIgnore) { }
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