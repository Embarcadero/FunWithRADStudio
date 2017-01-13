unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.Edit,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ExtCtrls, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.ObjectScope, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent, FMX.Calendar, DateUtils, System.Actions,
  FMX.ActnList, FMX.Objects, FMX.MultiView, System.Threading;

type
  TForm1 = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    ImageViewer1: TImageViewer;
    Edit1: TEdit;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    NetHTTPClient1: TNetHTTPClient;
    ActionList1: TActionList;
    GetImageAction: TAction;
    Timer1: TTimer;
    StyleBook1: TStyleBook;
    Text1: TText;
    LinkPropertyToFieldText: TLinkPropertyToField;
    MultiView1: TMultiView;
    Calendar1: TCalendar;
    ToolBar1: TToolBar;
    Button1: TButton;
    Layout1: TLayout;
    Layout2: TLayout;
    Pie1: TPie;
    Pie2: TPie;
    WorkingAnimation: TAction;
    procedure FormCreate(Sender: TObject);
    procedure GetImageActionExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Calendar1Change(Sender: TObject);
    procedure Pie1Click(Sender: TObject);
    procedure Pie2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BaseURL: String;
    BaseDate: String;
  end;
  const
   // get your key from https://api.nasa.gov/index.html#apply-for-an-api-key
   APIKey = 'DEMO_KEY';


var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Calendar1Change(Sender: TObject);
begin
BaseDate := YearOf(Calendar1.DateTime).ToString + '-' + MonthOfTheYear(Calendar1.DateTime).ToString + '-' + DayOfTheMonth(Calendar1.DateTime).ToString;
GetImageAction.Execute;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
BaseURL := 'https://api.nasa.gov/planetary/apod?api_key=' + APIKey;
end;

procedure TForm1.GetImageActionExecute(Sender: TObject);
var
AResponseStream: TMemoryStream;
begin
if BaseDate<>'' then
  begin
   RESTClient1.BaseURL := BaseURL + '&date=' + BaseDate;
  end
 else
  begin
    RESTClient1.BaseURL := BaseURL;
  end;
  ITask(TTask.Create(procedure
    begin
      TThread.Queue(nil,procedure
        begin
          RESTRequest1.Execute;
          AResponseStream := TMemoryStream.Create;
          NetHTTPClient1.Get(Edit1.Text,AResponseStream);
          try
           ImageViewer1.Bitmap.LoadFromStream(AResponseStream);
          except
          end;
          AResponseStream.Free;
        end);
    end)).Start;
end;

procedure TForm1.Pie1Click(Sender: TObject);
begin
Calendar1.Date := Calendar1.Date-1;
end;

procedure TForm1.Pie2Click(Sender: TObject);
begin
if (Calendar1.Date+1)>Now then Exit;
Calendar1.Date := Calendar1.Date+1;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
Timer1.Enabled := False;
Calendar1.Date := Now;
GetImageAction.Execute;
end;

end.
