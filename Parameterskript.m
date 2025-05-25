%% Zentrale Parameterdefinition für das Modell

% Die Simulink Parameter werden mit der Zusatzfunktion makeParam erstellt,
% dieser muss nur der Wert des Parameters übergeben werden. Mit dem Befehl
% assignin wird der Parametername und der Speicherort des Parameters
% übergeben (base steht für den Base Speicher / Workspace).

% Zum Erstellen eines neuen Parameters:
% assignin('base','Parametername', makeParam(Parameterwert));

%% ========================
% Allgemeine Umgebung
% =========================
assignin('base','mutrocken',makeParam(0.8));
assignin('base','munass',makeParam(0.4));
assignin('base','muschnee',makeParam(0.2));
assignin('base','g',makeParam(9.81));
assignin('base','Wetter',makeParam(1));
assignin('base','Szenario',makeParam(1));

%% ========================
% Ereignisse
% =========================
assignin('base','Haltezeit',makeParam(0.5));
assignin('base','Ausloesezeit',makeParam(0.5));
assignin('base','Airbagzeit',makeParam(0.1));

%% ========================
% Sensorik
% =========================
assignin('base','defaultDistance',makeParam(500));
assignin('base','Reichweite',makeParam(30));
assignin('base','ReichweiteA',makeParam(30));
assignin('base','ReichweiteB',makeParam(30));
assignin('base','Oeffnungswinkel',makeParam(30));
assignin('base','OeffnungswinkelA',makeParam(30));
assignin('base','OeffnungswinkelB',makeParam(30));
assignin('base','SensorSwitch',makeParam(0));
assignin('base','SensorA',makeParam(30));
assignin('base','SensorB',makeParam(30));
assignin('base','Relevanzbereich',makeParam(5));

%% ========================
% Fahrzeugdaten (bleiben konstant)
% =========================
assignin('base','mEGO',makeParam(-50));
assignin('base','mFZG',makeParam(-50));
assignin('base','P_EGO',makeParam(-50));
assignin('base','P_FZG',makeParam(-50));
assignin('base','l',makeParam(4.8));
assignin('base','b',makeParam(1.85));
assignin('base','rad_b',makeParam(0.25));
assignin('base','rad_l',makeParam(0.47));
assignin('base','reifen_dx',makeParam(0.2));
assignin('base','reifen_dy',makeParam(0.2));

%% ========================
% Szenario mit dem vorausfahrenden Fahrzeug
% =========================
assignin('base','zweitesFzgSwitch',makeParam(0));
assignin('base','startPositionFzg2',makeParam(20));

%% ========================
% Startpositionen und Geschwindigkeiten
% =========================
assignin('base','startPositionEGO',makeParam(-40));
assignin('base','startPositionFzg',makeParam(-40));
assignin('base','v_EGO',makeParam(10));
assignin('base','v_FZG',makeParam(10));
assignin('base','xFZG',makeParam(2.5));
assignin('base','yEGO',makeParam(-2.5));

%% ========================
% Simulation
% =========================
assignin('base','dt',makeParam(0.005));
assignin('base','sampletime',makeParam(0.03));
assignin('base','stoptime',makeParam(2));
assignin('base','Auswertungsflag',makeParam(0));
