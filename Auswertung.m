%% Skript zur Durchführung der automatischen Auswertung

% Dieses Skript durchläuft automatisiert eine Liste an Öffnungswinkeln
% deren Schrittweite zuvor in der GUI übergeben wurde. Nach Durchlauf der
% Öffungswinkel wird ein Auswertungsplot erstellt in dem man die
% verschiedenen Parameter (Erkennungszeitpunkt PufferzeitWarnung 
% PufferzeitBremsung PufferAbstand Kollisionsgeschwindigkeit 
% TimeToCollision) in Abhängigkeit des Öffnungswinkels dargestellt
% sind. 


function Auswertung()
    % Setzen des Flags
    assignin('base', 'Auswertungsflag', makeParam(1));
    
            
    % Wertebereich der Öffnungswinkel
    Winkelschrittweite = evalin('base','Winkelschrittweite.Value');
    winkelListe = 10:Winkelschrittweite:90;
    
    % Parameterwerte aus dem Workspace holen
    vEGO_param = evalin('base', 'v_EGO');
    vEGO_value = vEGO_param.Value;

    stoptime = evalin('base', 'stoptime.Value');

    % Parametervektoren initialisieren
    Anzahl = length(winkelListe);
    ErkennungszeitpunktAlle = NaN(1, Anzahl);
    PufferzeitWarnungAlle = NaN(1, Anzahl);
    PufferzeitBremsungAlle = NaN(1, Anzahl);
    PufferAbstandAlle = NaN(1, Anzahl);
    KollisionsgeschwindigkeitAlle = NaN(1, Anzahl);
    TimeToCollisionAlle = NaN(1, Anzahl);

    for i = 1:Anzahl
        winkel = winkelListe(i);

        % Öffnungswinkel setzen
        OeffnungswinkelB = Simulink.Parameter;
        OeffnungswinkelB.Value = winkel;
        OeffnungswinkelB.CoderInfo.StorageClass = 'ExportedGlobal';
        assignin('base', 'OeffnungswinkelB', OeffnungswinkelB);

        try
            disp(['Starte Simulation für Winkel = ', num2str(winkel), '°']);

            % Falls Simulation noch läuft -> stoppen
            if strcmp(get_param(FAS_Kreuzungswarner_Simulation_V1, 'SimulationStatus'), 'running')
                set_param(FAS_Kreuzungswarner_Simulation_V1, 'SimulationCommand', 'stop');
                pause(1);
            end

            % Simulation ausführen
            simOut = sim(FAS_Kreuzungswarner_Simulation_V1, 'StopTime', num2str(stoptime));

        catch simError
            warning(['Simulation fehlgeschlagen bei Winkel ', num2str(winkel), ': ', simError.message]);
            continue;
        end

        % Parametervektoren lesen 
        ErkennungszeitpunktAlle(i) = getVarSafe('Erkennungszeitpunkt');
        PufferzeitWarnungAlle(i) = getVarSafe('PufferzeitWarnung');
        PufferzeitBremsungAlle(i) = getVarSafe('PufferzeitBremsung');
        PufferAbstandAlle(i) = getVarSafe('PufferAbstand');
        KollisionsgeschwindigkeitAlle(i) = getVarSafe('Kollisionsgeschwindigkeit');
        TimeToCollisionAlle(i) = getVarSafe('TimeToCollision');

        % Absicherung ob der richtiger Winkel übernommen wurde
        istWinkel = evalin('base', 'OeffnungswinkelB.Value');
        if istWinkel ~= winkel
            fprintf("Falscher Winkel gesetzt: Soll = %d°, Ist = %d° → Wiederholung...\n", winkel, istWinkel);
            i = i - 1;  
        end
    end

    % Plotten der Ergebnisse
    figure;

    subplot(6,1,1); plot(winkelListe, ErkennungszeitpunktAlle, '-x');
    ylabel('Erkennung in s'); 
    axis([10 90 0 7]); 
    grid on;

    subplot(6,1,2); plot(winkelListe, PufferzeitWarnungAlle, '-x');
    ylabel('Puffer Warnung in s'); 
    axis([10 90 0 7]); 
    grid on;

    subplot(6,1,3); plot(winkelListe, PufferzeitBremsungAlle, '-x');
    ylabel('Puffer Bremsung in s'); 
    axis([10 90 0 7]); 
    grid on;

    subplot(6,1,4); plot(winkelListe, PufferAbstandAlle, '-x');
    ylabel('Puffer Abstand in m'); 
    axis([10 90 0 11]); 
    grid on;

    subplot(6,1,5); plot(winkelListe, KollisionsgeschwindigkeitAlle, '-x');
    ylabel('Koll.geschw. in km/h'); 
    v_Wertmax = vEGO_value + 10;
    axis([10 90 0 v_Wertmax]);
    grid on;

    subplot(6,1,6); plot(winkelListe, TimeToCollisionAlle, '-x');
    ylabel('Time to Collision in s'); 
    xlabel('Öffnungswinkel in °'); 
    axis([10 90 0 1.5]);
    grid on;

    sgtitle(sprintf('Auswertung bei %.1f km/h', vEGO_value));

    assignin('base', 'Auswertungsflag', makeParam(0));
    assignin('base','Auswertungsbutton', makeParam(0));
end

function val = getVarSafe(varname)
    if evalin('base', ['exist(''',varname,''',''var'')'])
        val = evalin('base', varname);
    else
        val = NaN;
    end
end