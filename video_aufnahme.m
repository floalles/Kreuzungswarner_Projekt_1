%% Anleitung zur Nutzung der Videanleitung ================================

% Beim Ersten Ausführen möglicherweise Fehlermeldung:
% Warning: No video frames were written to this file. The file may be invalid. 
% > In VideoWriter/close (line 282)
% In VideoWriter/delete (line 217)
% In video_aufnahme (line 30)
% --> Kann Ignoriert werden, Video dennoch aufgezeichnet

% Vorgehen
% 1. Name des Simulationsmodelles 2 mal eintragen
% 2. Zielpfad muss eingetragen werden
%    -> Ordner wird automatisch erstellt wenn nicht vorhanden
% 3. Simulationsmodell muss geöffnet sein
% 4. video_aufnahme Skript ausführen
%    -> Simulation wird gestartet und GUI öffnet sich
% 5. Paremeter und Szenario in der GUI wählen und ausführen
% 6. Ausgabe im Terminal beachten bis bestätigung des Speicherns

%% ========================================================================
disp('Simulation wird gestartet und Szenarienauswahl Abfrage...');
% Simulationsstart
set_param('FAS_Kreuzungswarner_Simulation_V1', 'SimulationCommand', 'start');  % Modellname einfügen
disp('Simulation gestartet...');


%% Hier den Pfad eintragen ================================================================================
videoDir = 'Individuell\Videos';   % Pfad wo Video gespeichert wird
if ~exist(videoDir, 'dir')
    mkdir(videoDir);                                % Erstellt einen Ordner wenn noch nicht vorhanden
end
%% ========================================================================================================


% Temporärer Video-Pfad (wird später umbenannt) da zu beginn noch kein
% Szenario ausgewählt
tempVideoPath = fullfile(videoDir, ['temp_video_' datestr(now, 'yyyy-mm-dd_HH-MM') '.mp4']);
videoObj = VideoWriter(tempVideoPath, 'MPEG-4');
videoObj.FrameRate = 30;
open(videoObj);

disp('Szenarien Auswahl per Gui erfolgreich gestartet...');

% Warten auf die Figures (Simulation läuft)
while isempty(findobj('Type', 'figure', 'Number', 1)) || isempty(findobj('Type', 'figure', 'Number', 2))
    pause(0.1);
end

disp('Figures erkannt, starte Videoaufnahme...');

% Videoaufnahme
while strcmp(get_param('FAS_Kreuzungswarner_Simulation_V1', 'SimulationStatus'), 'running')  % Modellname einfügen

    % Frame der ersten Figure (Fahrzeugwelt) aufnehmen
    figure(1);
    frame1 = getframe(gcf);
    
    % Frame der zweiten Figure (HMI) aufnehmen
    figure(2);
    frame2 = getframe(gcf);
    
    % Beide Frames nebeneinander kombinieren
    combinedFrame = [frame1.cdata, frame2.cdata];
    
    % In das Video schreiben
    writeVideo(videoObj, combinedFrame);
    
    % Kurze Pause (an die Simulationsgeschwindigkeit anpassen)
    pause(0.033);  % ca. 30 FPS

end

% Video speichern und beenden
close(videoObj);

% Szenario aus dem Workspace holen (nach der Simulation)
disp('Abfrage Szenario für Video-Name...');
SzenarioParam = evalin('base', 'Szenario');
scenarioNames = {
    'Trocken_30kmh_beide', ...
    'Trocken_30kmh_beide_Kamera', ...
    'Trocken_30kmh_beide_Radar', ...
    'Trocken_50kmh_beide', ...
    'Trocken_50kmh_beide_Kamera', ...
    'Trocken_50kmh_beide_Radar', ...
    'Trocken_70kmh_beide', ...
    'Trocken_70kmh_beide_Kamera', ...
    'Trocken_70kmh_beide_Radar', ...
    'Trocken_100kmh_beide', ...
    'Trocken_100kmh_beide_Kamera', ...
    'Trocken_100kmh_beide_Radar', ...
    'Regen_30kmh_beide', ...
    'Regen_30kmh_beide_Kamera', ...
    'Regen_30kmh_beide_Radar', ...
    'Regen_50kmh_beide', ...
    'Regen_50_kmh_beide_Kamera', ...
    'Regen_50_kmh_beide_Radar', ...
    'Regen_70_kmh_beide', ...
    'Regen_70_kmh_beide_Kamera', ...
    'Regen_70_kmh_beide_Radar', ...
    'Regen_100_kmh_beide', ...
    'Regen_100kmh_beide_Kamera', ...
    'Regen_100kmh_beide_Radar', ...
    'Schnee_30_kmh_beide', ...
    'Schnee_50_kmh_beide', ...
    'Schnee_70kmh_beide', ...
    'Schnee_100kmh_beide', ...
    'Trocken_30_kmh_EGO_50_kmh_Fzg', ...
    'Trocken_50_kmh_EGO_30_kmh_Fzg',...
    'Regen_30_kmh_EGO_50_kmh_Fzg', ...
    'Regen_50_kmh_EGO_30_kmh_Fzg',...
    'Vorausfahrendes_Fahrzeug_bei_30_kmh',...
    'Unfallszenario'};

% Szenario abfragen und benennen
if isa(SzenarioParam, 'Simulink.Parameter')
    Szenario = SzenarioParam.Value;
elseif isnumeric(SzenarioParam)
    Szenario = SzenarioParam;
else
    Szenario = 0;
end

% Szenarioname bestimmen
if Szenario > 0 && Szenario <= length(scenarioNames)
    videoName = scenarioNames{Szenario};
else
    videoName = 'Unbekanntes_Szenario';
end

% Video umbenennen mit korrektem Szenarionamen
finalVideoPath = fullfile(videoDir, [videoName '_' datestr(now, 'yyyy-mm-dd_HH-MM') '.mp4']);
movefile(tempVideoPath, finalVideoPath);

disp(['Video erfolgreich gespeichert unter: ', finalVideoPath]);
fprintf('\n');


