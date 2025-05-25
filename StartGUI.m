%% Eingabeoberfläche zum Starten einer Simulation / Auswertung

% Dieses Skript erstellt die gesamte Eingabeoberfläche und ist in
% verschiedene Funktionen aufgeteilt.

%% function StartGUI 
% In dieser Funktion wird das optische Grundmodell erstellt in dem die
% verschiedenen Eingabemöglichkeiten dargestellt sind. Diese sind 
% aufgeteilt in eine linke und rechte Spalte, sowie die Unterscheidung 
% zwischen einer einzelnen Simulation oder einer gesamten Auswertung.
% Zusätzlich wird auch die Art und Weise mit der man die Parameter ändern 
% kann (z.B. Dropdown Menü, manuelle Eingabe des Werts, Knopfdruck) in
% dieser Funktion festgelegt.

%% function Parametersetzen(~,~)
% In dieser Funktion werden die Parameter aus der GUI in die Base
% (Workspace) geschrieben.

%% function Auswertungstarten(~, ~)
% Prüft ob der Auswertungsknopf gedrückt wurde und setzt dann die
% entsprechenden Flags im Workspace, sodass eine automatische Auswertung
% gestartet werden kann.

%% function updateSzenario(index)
% Setzt die voreingestellten Werte anhand des übergebenen Szenarios.

function StartGUI
    f = figure('Name','Simulationsparameter setzen','Position',[400 200 1000 800], ...
        'NumberTitle','off','MenuBar','none','Resize','off','CloseRequestFcn', @onClose);

    %% Linke Spalte ------------------------------------
    % Allgemeine Simulation
    panelSim = uipanel(f,'Title','Allgemeine Simulation','FontSize',10, ...
        'Position',[0.05 0.65 0.4 0.3]);

    uicontrol(panelSim,'Style','text','Position',[10 155 140 20],'String','Startposition EGO [m]:');
    posEGOInput = uicontrol(panelSim,'Style','edit','Position',[200 155 100 20],'String','-50');

    uicontrol(panelSim,'Style','text','Position',[10 115 140 20],'String','Startposition Fzg [m]:');
    posFzgInput = uicontrol(panelSim,'Style','edit','Position',[200 115 100 20],'String','-50');    

    uicontrol(panelSim,'Style','text','Position',[10 75 140 20],'String','Sample Time [s]:');
    sampletimeInput = uicontrol(panelSim,'Style','edit','Position',[200 75 100 20],'String','0.03');

    uicontrol(panelSim,'Style','text','Position',[10 35 140 20],'String','Stop Time [s]:');
    stoptimeInput = uicontrol(panelSim,'Style','edit','Position',[200 35 100 20],'String','8');

    % Sensorparameter mit Dropdown Menü
    panelSensor = uipanel(f,'Title','Sensorparameter','FontSize',10, ...
        'Position',[0.05 0.25 0.4 0.37]);

    % Sensor-Auswahl Dropdown Menü
    uicontrol(panelSensor,'Style','text','Position',[10 230 140 15],'String','Sensor A Typ:');
    sensor1Dropdown = uicontrol(panelSensor,'Style','popupmenu', ...
        'Position',[200 230 100 20],'String',{'C2X','God Sensor','---'});

    uicontrol(panelSensor,'Style','text','Position',[10 190 140 15],'String','Sensor B Typ:');
    sensor2Dropdown = uicontrol(panelSensor,'Style','popupmenu', ...
        'Position',[200 190 100 20],'String',{'Radar','Kamera','---'});

    % Winkel und Reichweite
    uicontrol(panelSensor,'Style','text','Position',[10 150 140 20],'String','Öffnungswinkel A [deg]:');
    angleInputA = uicontrol(panelSensor,'Style','edit','Position',[200 150 100 25],'String','360');

    uicontrol(panelSensor,'Style','text','Position',[10 110 140 20],'String','Öffnungswinkel B [deg]:');
    angleInputB = uicontrol(panelSensor,'Style','edit','Position',[200 110 100 25],'String','30');

    uicontrol(panelSensor,'Style','text','Position',[10 70 140 20],'String','Reichweite A [m]:');
    rangeInputA = uicontrol(panelSensor,'Style','edit','Position',[200 70 100 25],'String','500');

    uicontrol(panelSensor,'Style','text','Position',[10 30 140 20],'String','Reichweite B [m]:');
    rangeInputB = uicontrol(panelSensor,'Style','edit','Position',[200 30 100 25],'String','80');

    % Wetterbedingungen
    panelWeather = uipanel(f,'Title','Wetterbedingungen','FontSize',10, ...
        'Position',[0.05 0.1 0.4 0.12]);

    uicontrol(panelWeather,'Style','text','Position',[10 25 140 20],'String','Wetter:' );
    weatherDropdown = uicontrol(panelWeather,'Style','popupmenu', ...
        'Position',[200 25 100 25],'String',{'Trocken','Regen','Schnee'});


    %% Rechte Spalte ------------------------------------
    if~(evalin('base', 'exist(''Auswertungsbutton'', ''var'')') && evalin('base', 'Auswertungsbutton.Value == 1'))
        % EGO Fahrzeug
        panelEGO = uipanel(f,'Title','Fahrzeugdaten EGO','FontSize',10, ...
            'Position',[0.55 0.45 0.4 0.25]);
    
        uicontrol(panelEGO,'Style','text','Position',[10 110 140 20],'String','Masse [kg]:');
        massEGOInput = uicontrol(panelEGO,'Style','edit','Position',[200 110 100 25],'String','1500');
    
        uicontrol(panelEGO,'Style','text','Position',[10 70 140 20],'String','Leistung [kW]:');
        powerEGOInput = uicontrol(panelEGO,'Style','edit','Position',[200 70 100 25],'String','100');
    
        uicontrol(panelEGO,'Style','text','Position',[10 30 140 20],'String','Startgeschwindigkeit [km/h]:');
        velEGOInput = uicontrol(panelEGO,'Style','edit','Position',[200 30 100 25],'String','30');
    
        % Anderes Fahrzeug
        panelFZG = uipanel(f,'Title','Fahrzegudaten anderes Fzg','FontSize',10, ...
            'Position',[0.55 0.15 0.4 0.25]);
    
        uicontrol(panelFZG,'Style','text','Position',[10 110 140 20],'String','Masse [kg]:');
        massFZGInput = uicontrol(panelFZG,'Style','edit','Position',[200 110 100 25],'String','1500');
    
        uicontrol(panelFZG,'Style','text','Position',[10 70 140 20],'String','Leistung [kW]:');
        powerFZGInput = uicontrol(panelFZG,'Style','edit','Position',[200 70 100 25],'String','110');
    
        uicontrol(panelFZG,'Style','text','Position',[10 30 140 20],'String','Startgeschwindigkeit [km/h]:');
        velFZGInput = uicontrol(panelFZG,'Style','edit','Position',[200 30 100 25],'String','30');
    
        zweitesFzgInput = uicontrol(panelFZG,'Style','edit','Position',[200 30 0 0],'String','0');
        
        % Szenarienauswahl Dropdown Menü   
        panelSzenario = uipanel(f,'Title','Szenarienauswahl','FontSize',10, ...
            'Position',[0.55 0.75 0.4 0.13]);
    
        uicontrol(panelSzenario,'Style','text','Position',[10 25 140 20],'String','Szenarien:' );
        SzenarioDropdown = uicontrol(panelSzenario,'Style','popupmenu', ...
            'Position',[180 25 200 25],'String',{   'Trocken, 30 km/h (beide Fzg)', ...
                                                    'Trocken, 30 km/h (beide Fzg), nur Kamera', ...
                                                    'Trocken, 30 km/h (beide Fzg), nur Radar', ...
                                                    'Trocken, 50 km/h (beide Fzg)', ...
                                                    'Trocken, 50 km/h (beide Fzg), nur Kamera', ...
                                                    'Trocken, 50 km/h (beide Fzg), nur Radar', ...
                                                    'Trocken, 70 km/h (beide Fzg)', ...
                                                    'Trocken, 70 km/h (beide Fzg), nur Kamera', ...
                                                    'Trocken, 70 km/h (beide Fzg), nur Radar', ...
                                                    'Trocken, 100 km/h (beide Fzg)', ...
                                                    'Trocken, 100 km/h (beide Fzg), nur Kamera', ...
                                                    'Trocken, 100 km/h (beide Fzg), nur Radar', ...
                                                    'Regen, 30 km/h (beide Fzg)', ...
                                                    'Regen, 30 km/h (beide Fzg), nur Kamera', ...
                                                    'Regen, 30 km/h (beide Fzg), nur Radar', ...
                                                    'Regen, 50 km/h (beide Fzg)', ...
                                                    'Regen, 50 km/h (beide Fzg), nur Kamera', ...
                                                    'Regen, 50 km/h (beide Fzg), nur Radar', ...
                                                    'Regen, 70 km/h (beide Fzg)', ...
                                                    'Regen, 70 km/h (beide Fzg), nur Kamera', ...
                                                    'Regen, 70 km/h (beide Fzg), nur Radar', ...
                                                    'Regen, 100 km/h (beide Fzg)', ...
                                                    'Regen, 100 km/h (beide Fzg), nur Kamera', ...
                                                    'Regen, 100 km/h (beide Fzg), nur Radar', ...
                                                    'Schnee, 30 km/h (beide Fzg)', ...
                                                    'Schnee, 50 km/h (beide Fzg)', ...
                                                    'Schnee, 70 km/h (beide Fzg)', ...
                                                    'Schnee, 100 km/h (beide Fzg)', ...
                                                    'Trocken, 30 km/h (EGO), 50 km/h (Fzg)', ...
                                                    'Trocken, 50 km/h (EGO), 30 km/h (Fzg)',...
                                                    'Regen, 30 km/h (EGO), 50 km/h (Fzg)', ...
                                                    'Regen, 50 km/h (EGO), 30 km/h (Fzg)',...
                                                    'Vorausfahrendes Fahrzeug bei 30 km/h',...
                                                    'Unfallszenario'});
    
        SzenarioDropdown.Callback = @(src, event) updateSzenario(src.Value);
    else
        % Auswertung starten
        panelAuswertung = uipanel(f,'Title','Auswertung','FontSize',10, ...
            'Position',[0.55 0.83 0.4 0.12]);
    
        uicontrol(panelAuswertung,'Style','text','Position',[10 30 140 20],'String','Schrittweite des Winkels [°]:');
        WinkelschrittweiteInput = uicontrol(panelAuswertung,'Style','edit','Position',[200 30 100 25],'String','80');
    
        % EGO Fahrzeug
        panelEGO = uipanel(f,'Title','Fahrzeugdaten EGO','FontSize',10, ...
            'Position',[0.55 0.39 0.4 0.25]);
    
        uicontrol(panelEGO,'Style','text','Position',[10 110 140 20],'String','Masse [kg]:');
        massEGOInput = uicontrol(panelEGO,'Style','edit','Position',[200 110 100 25],'String','1500');
    
        uicontrol(panelEGO,'Style','text','Position',[10 70 140 20],'String','Leistung [kW]:');
        powerEGOInput = uicontrol(panelEGO,'Style','edit','Position',[200 70 100 25],'String','100');
    
        uicontrol(panelEGO,'Style','text','Position',[10 30 140 20],'String','Startgeschwindigkeit [km/h]:');
        velEGOInput = uicontrol(panelEGO,'Style','edit','Position',[200 30 100 25],'String','30');
    
        % Anderes Fahrzeug
        panelFZG = uipanel(f,'Title','Fahrzegudaten anderes Fzg','FontSize',10, ...
            'Position',[0.55 0.1 0.4 0.25]);
    
        uicontrol(panelFZG,'Style','text','Position',[10 110 140 20],'String','Masse [kg]:');
        massFZGInput = uicontrol(panelFZG,'Style','edit','Position',[200 110 100 25],'String','1500');
    
        uicontrol(panelFZG,'Style','text','Position',[10 70 140 20],'String','Leistung [kW]:');
        powerFZGInput = uicontrol(panelFZG,'Style','edit','Position',[200 70 100 25],'String','110');
    
        uicontrol(panelFZG,'Style','text','Position',[10 30 140 20],'String','Startgeschwindigkeit [km/h]:');
        velFZGInput = uicontrol(panelFZG,'Style','edit','Position',[200 30 100 25],'String','30');
    
        zweitesFzgInput = uicontrol(panelFZG,'Style','edit','Position',[200 30 0 0],'String','0');
        
        % Szenarienauswahl Dropdown Menü
        panelSzenario = uipanel(f,'Title','Szenarienauswahl','FontSize',10, ...
            'Position',[0.55 0.68 0.4 0.12]);
    
        uicontrol(panelSzenario,'Style','text','Position',[10 25 140 20],'String','Szenarien:' );
        SzenarioDropdown = uicontrol(panelSzenario,'Style','popupmenu', ...
            'Position',[180 25 200 25],'String',{   'Trocken, 30 km/h (beide Fzg)', ...
                                                    'Trocken, 30 km/h (beide Fzg), nur Kamera', ...
                                                    'Trocken, 30 km/h (beide Fzg), nur Radar', ...
                                                    'Trocken, 50 km/h (beide Fzg)', ...
                                                    'Trocken, 50 km/h (beide Fzg), nur Kamera', ...
                                                    'Trocken, 50 km/h (beide Fzg), nur Radar', ...
                                                    'Trocken, 70 km/h (beide Fzg)', ...
                                                    'Trocken, 70 km/h (beide Fzg), nur Kamera', ...
                                                    'Trocken, 70 km/h (beide Fzg), nur Radar', ...
                                                    'Trocken, 100 km/h (beide Fzg)', ...
                                                    'Trocken, 100 km/h (beide Fzg), nur Kamera', ...
                                                    'Trocken, 100 km/h (beide Fzg), nur Radar', ...
                                                    'Regen, 30 km/h (beide Fzg)', ...
                                                    'Regen, 30 km/h (beide Fzg), nur Kamera', ...
                                                    'Regen, 30 km/h (beide Fzg), nur Radar', ...
                                                    'Regen, 50 km/h (beide Fzg)', ...
                                                    'Regen, 50 km/h (beide Fzg), nur Kamera', ...
                                                    'Regen, 50 km/h (beide Fzg), nur Radar', ...
                                                    'Regen, 70 km/h (beide Fzg)', ...
                                                    'Regen, 70 km/h (beide Fzg), nur Kamera', ...
                                                    'Regen, 70 km/h (beide Fzg), nur Radar', ...
                                                    'Regen, 100 km/h (beide Fzg)', ...
                                                    'Regen, 100 km/h (beide Fzg), nur Kamera', ...
                                                    'Regen, 100 km/h (beide Fzg), nur Radar', ...
                                                    'Schnee, 30 km/h (beide Fzg)', ...
                                                    'Schnee, 50 km/h (beide Fzg)', ...
                                                    'Schnee, 70 km/h (beide Fzg)', ...
                                                    'Schnee, 100 km/h (beide Fzg)', ...
                                                    'Trocken, 30 km/h (EGO), 50 km/h (Fzg)', ...
                                                    'Trocken, 50 km/h (EGO), 30 km/h (Fzg)',...
                                                    'Regen, 30 km/h (EGO), 50 km/h (Fzg)', ...
                                                    'Regen, 50 km/h (EGO), 30 km/h (Fzg)',...
                                                    'Vorausfahrendes Fahrzeug bei 30 km/h',...
                                                    'Unfallszenario'});
    
        SzenarioDropdown.Callback = @(src, event) updateSzenario(src.Value);
        
        % Button zum Starten der automatischen Auswertung
        uicontrol(f,'Style','pushbutton','String','Auswertung starten', ...
            'FontSize',10,'Position',[375 20 260 40],'Callback', @Auswertungstarten);
        uiwait(f);
    end

    % Button zum Starten einer einzelnen Simulation
    if~(evalin('base', 'exist(''Auswertungsbutton'', ''var'')') && evalin('base', 'Auswertungsbutton.Value == 1'))
        uicontrol(f,'Style','pushbutton','String','Parameter setzen und Simulation starten', ...
            'FontSize',10,'Position',[375 20 260 40],'Callback',@Parametersetzen);
    
        uiwait(f);
    end
    
    function Parametersetzen(~,~)
        % Allgemein
        startPositionEGO = str2double(posEGOInput.String);
        startPositionFzg = str2double(posFzgInput.String);
        sampletime = str2double(sampletimeInput.String);
        stoptime = str2double(stoptimeInput.String);

        % Sensor
        OeffnungswinkelA = str2double(angleInputA.String);
        OeffnungswinkelB = str2double(angleInputB.String);
        ReichweiteA = str2double(rangeInputA.String);
        ReichweiteB = str2double(rangeInputB.String);
        SensorA = sensor1Dropdown.Value;
        SensorB = sensor2Dropdown.Value;

        % Wetter
        Wetter = weatherDropdown.Value;

        % Fahrzeuge
        mEGO = str2double(massEGOInput.String);
        mFZG = str2double(massFZGInput.String);
        P_EGO = str2double(powerEGOInput.String);
        P_FZG = str2double(powerFZGInput.String);
        v_EGO = str2double(velEGOInput.String);
        v_FZG = str2double(velFZGInput.String);
        zweitesFzgSwitch = str2double(zweitesFzgInput.String);

        % Szenario
        Szenario = SzenarioDropdown.Value;

        % Auswertung
        if(evalin('base', 'exist(''Auswertungsbutton'', ''var'')') && evalin('base', 'Auswertungsbutton.Value == 1'))
            Winkelschrittweite = str2double(WinkelschrittweiteInput.String);
        end

        % In den Workspace schreiben
        assignin('base','startPositionEGO',makeParam(startPositionEGO));
        assignin('base','startPositionFzg',makeParam(startPositionFzg));
        assignin('base','sampletime',makeParam(sampletime));
        assignin('base','stoptime',makeParam(stoptime));
        assignin('base','OeffnungswinkelA',makeParam(OeffnungswinkelA));
        assignin('base','OeffnungswinkelB',makeParam(OeffnungswinkelB));
        assignin('base','ReichweiteA',makeParam(ReichweiteA));
        assignin('base','ReichweiteB',makeParam(ReichweiteB));
        assignin('base','SensorA',makeParam(SensorA));
        assignin('base','SensorB',makeParam(SensorB));
        assignin('base','Wetter',makeParam(Wetter));
        assignin('base','mEGO',makeParam(mEGO));
        assignin('base','mFZG',makeParam(mFZG));
        assignin('base','P_EGO',makeParam(P_EGO));
        assignin('base','P_FZG',makeParam(P_FZG));
        assignin('base','v_EGO',makeParam(v_EGO));
        assignin('base','v_FZG',makeParam(v_FZG));
        assignin('base','Szenario',makeParam(Szenario));
        assignin('base','zweitesFzgSwitch',makeParam(zweitesFzgSwitch));


        if(evalin('base', 'exist(''Auswertungsbutton'', ''var'')') && evalin('base', 'Auswertungsbutton.Value == 1'))
            assignin('base','Winkelschrittweite',makeParam(Winkelschrittweite));
        end

        % GUI schließen
        uiresume(f);
        delete(f);
    end

    function Auswertungstarten(~, ~)
        if(evalin('base', 'exist(''Auswertungsbutton'', ''var'')') && evalin('base', 'Auswertungsbutton.Value == 1'))
            assignin('base', 'StarteAuswertungJetzt', makeParam(1));
            Parameterskript();
            % Parameter aus GUI setzen
            Parametersetzen();
        end
    end

    % Prüfen, ob Auswertung gewünscht ist
    if(evalin('base', 'exist(''Auswertungsbutton'', ''var'')') && evalin('base', 'Auswertungsbutton.Value == 1'))
        if evalin('base', 'exist(''StarteAuswertungJetzt'', ''var'')') && evalin('base', 'StarteAuswertungJetzt.Value == 1')
            assignin('base', 'StarteAuswertungJetzt',makeParam(0));  
            disp("Starte Auswertung");
            evalin('base', 'Auswertung;');  
        end
    end

    function updateSzenario(index)
        switch index
            case 1  % Trocken, 30 km/h (beide Fzg)
                velEGOInput.String = '30';
                velFZGInput.String = '30';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 2  % Trocken, 30 km/h (beide Fzg), nur Kamera
                velEGOInput.String = '30';
                velFZGInput.String = '30';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 2;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 3  % Trocken, 30 km/h (beide Fzg), nur Radar
                velEGOInput.String = '30';
                velFZGInput.String = '30';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1; 
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 4  % Trocken, 50 km/h (beide Fzg)
                velEGOInput.String = '50';
                velFZGInput.String = '50';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '6';
                zweitesFzgInput.String = '0';

            case 5  % Trocken, 50 km/h (beide Fzg), nur Kamera
                velEGOInput.String = '50';
                velFZGInput.String = '50';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 2;
                stoptimeInput.String = '6';
                zweitesFzgInput.String = '0';

            case 6  % Trocken, 50 km/h (beide Fzg), nur Radar
                velEGOInput.String = '50';
                velFZGInput.String = '50';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1; 
                stoptimeInput.String = '6';
                zweitesFzgInput.String = '0';

            case 7  % Trocken, 70 km/h (beide Fzg)
                velEGOInput.String = '70';
                velFZGInput.String = '70';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '5';
                zweitesFzgInput.String = '0';

            case 8  % Trocken, 70 km/h (beide Fzg), nur Kamera
                velEGOInput.String = '70';
                velFZGInput.String = '70';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 2;
                stoptimeInput.String = '5';
                zweitesFzgInput.String = '0';
                
            case 9  % Trocken, 70 km/h (beide Fzg), nur Radar
                velEGOInput.String = '70';
                velFZGInput.String = '70';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '5';
                zweitesFzgInput.String = '0';

            case 10  % Trocken, 100 km/h (beide Fzg)
                velEGOInput.String = '100';
                velFZGInput.String = '100';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '3';
                zweitesFzgInput.String = '0';
            
            case 11  % Trocken, 100 km/h (beide Fzg), nur Kamera
                velEGOInput.String = '100';
                velFZGInput.String = '100';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 2;
                stoptimeInput.String = '3';
                zweitesFzgInput.String = '0';
                
            case 12  % Trocken, 100 km/h (beide Fzg), nur Radar
                velEGOInput.String = '100';
                velFZGInput.String = '100';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '3';
                zweitesFzgInput.String = '0';

            case 13  % Regen, 30 km/h (beide Fzg)
                velEGOInput.String = '30';
                velFZGInput.String = '30';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 14  % Regen, 30 km/h (beide Fzg), nur Kamera
                velEGOInput.String = '30';
                velFZGInput.String = '30';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 2;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 15  % Regen, 30 km/h (beide Fzg), nur Radar
                velEGOInput.String = '30';
                velFZGInput.String = '30';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 16  % Regen, 50 km/h (beide Fzg)
                velEGOInput.String = '50';
                velFZGInput.String = '50';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '6';
                zweitesFzgInput.String = '0';

            case 17  % Regen, 50 km/h (beide Fzg), nur Kamera
                velEGOInput.String = '50';
                velFZGInput.String = '50';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 2;
                stoptimeInput.String = '6';
                zweitesFzgInput.String = '0';

            case 18  % Regen, 50 km/h (beide Fzg), nur Radar
                velEGOInput.String = '50';
                velFZGInput.String = '50';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '5';
                zweitesFzgInput.String = '0';

            case 19  % Regen, 70 km/h (beide Fzg)
                velEGOInput.String = '70';
                velFZGInput.String = '70';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '5';
                zweitesFzgInput.String = '0';
            
            case 20  % Regen, 70 km/h (beide Fzg), nur Kamera
                velEGOInput.String = '70';
                velFZGInput.String = '70';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 2;
                stoptimeInput.String = '5';
                zweitesFzgInput.String = '0';

            case 21  % Regen, 70 km/h (beide Fzg), nur Radar
                velEGOInput.String = '70';
                velFZGInput.String = '70';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '5';
                zweitesFzgInput.String = '0';

            case 22  % Regen, 100 km/h (beide Fzg)
                velEGOInput.String = '100';
                velFZGInput.String = '100';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '3';
                zweitesFzgInput.String = '0';

            case 23  % Regen, 100 km/h (beide Fzg), nur Kamera
                velEGOInput.String = '100';
                velFZGInput.String = '100';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 2;
                stoptimeInput.String = '3';
                zweitesFzgInput.String = '0';

            case 24  % Regen, 100 km/h (beide Fzg), nur Radar
                velEGOInput.String = '100';
                velFZGInput.String = '100';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '3';
                zweitesFzgInput.String = '0';

            case 25  % Schnee, 30 km/h (beide Fzg)
                velEGOInput.String = '30';
                velFZGInput.String = '30';
                weatherDropdown.Value = 3;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 26  % Schnee, 50 km/h (beide Fzg)
                velEGOInput.String = '50';
                velFZGInput.String = '50';
                weatherDropdown.Value = 3;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '6';
                zweitesFzgInput.String = '0';
            
            case 27  % Schnee, 70 km/h (beide Fzg)
                velEGOInput.String = '70';
                velFZGInput.String = '70';
                weatherDropdown.Value = 3;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '5';
                zweitesFzgInput.String = '0';
            
            case 28  % Schnee, 100 km/h (beide Fzg)
                velEGOInput.String = '100';
                velFZGInput.String = '100';
                weatherDropdown.Value = 3;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '3';
                zweitesFzgInput.String = '0';

            case 29  % Trocken, 30 km/h (EGO), 50 km/h (Fzg)
                velEGOInput.String = '30';
                velFZGInput.String = '50';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 30 % Trocken, 50 km/h (EGO), 30 km/h (Fzg)
                velEGOInput.String = '50';
                velFZGInput.String = '30';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';
            
            case 31  % Regen, 30 km/h (EGO), 50 km/h (Fzg)
                velEGOInput.String = '30';
                velFZGInput.String = '50';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 32 % Regen, 50 km/h (EGO), 30 km/h (Fzg)
                velEGOInput.String = '50';
                velFZGInput.String = '30';
                weatherDropdown.Value = 2;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8';
                zweitesFzgInput.String = '0';

            case 33 % Vorausfahrendes Fzg bei 30 km/h
                velEGOInput.String = '30';
                velFZGInput.String = '30';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 1;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '8'; 
                zweitesFzgInput.String = '1';

            case 34 % Unfallszenario
                velEGOInput.String = '90';
                velFZGInput.String = '90';
                weatherDropdown.Value = 1;
                sensor1Dropdown.Value = 3;
                sensor2Dropdown.Value = 1;
                stoptimeInput.String = '2.5'; 
                zweitesFzgInput.String = '0';
        end
    end
end