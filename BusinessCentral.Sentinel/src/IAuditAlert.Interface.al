namespace STM.BusinessCentral.Sentinel;

interface IAuditAlertSESTM
{
    Access = Public;

    procedure CreateAlerts()
    procedure ShowMoreDetails(var Alert: Record AlertSESTM)
    procedure RunActionRecommendations(var Alert: Record AlertSESTM)
}