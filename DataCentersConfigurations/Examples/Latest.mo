within DataCentersConfigurations.Examples;
model Latest
parameter Real TAirset = 273.15 + 18 "[K]";
  parameter Real TFreeze=273.15 + 3 "[K]";
  parameter Real TCHWsupset = 273.15 + 14 "[K]";
  parameter Real TAppNominal = 5 "[K]";
  parameter Real ITLoad = 500000 "[W]";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=ITLoad/(
      1005*7) "Nominal mass flow rate at fan";
  parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal=24.28 "Nominal mass flow rate at chilled water";

  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal= 30.28 "Nominal mass flow rate at condenser water";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=500
    "Nominal pressure difference";
  replaceable DataCentersConfigurations.Architecture.DataCenter TestBed(
    mAir_flow_nominal=mAir_flow_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    dp_nominal=dp_nominal,
    TApp_nominal=TAppNominal) annotation (Placement(transformation(
          extent={{-6,2},{24,48}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam=
        "D:/Github/DataCenterArchitecture/weather/8.mos")
    annotation (Placement(transformation(extent={{-100,40},{-88,52}})));
  Modelica.Blocks.Sources.Constant Architecture(k=7)
    annotation (Placement(transformation(extent={{-100,20},{-90,30}})));
  Controls.TrimandResponse.ChiWSE Control(
    TAirset=TAirset,
    TFreeze=TFreeze,
    TCHWsupset=TCHWsupset,
    ITLoad=ITLoad,
    mAir_flow_nominal=mAir_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal)
    annotation (Placement(transformation(extent={{-80,0},{-46,50}})));
equation
  connect(weaData.weaBus, Control.weaBus) annotation (Line(
      points={{-88,46},{-80,46},{-80,45.8333}},
      color={255,204,51},
      thickness=0.5));
  connect(Architecture.y, Control.u)
    annotation (Line(points={{-89.5,25},{-81.02,25}}, color={0,0,127}));
  connect(Control.Control, TestBed.Control) annotation (Line(
      points={{-45.66,25.4167},{-6,25.4167},{-6,25.8},{-5.8,25.8}},
      color={255,204,51},
      thickness=0.5));
  connect(TestBed.Temperature, Control.Temperature) annotation (Line(
      points={{24.2,26},{40,26},{40,-6},{-63,-6},{-63,3.75}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -20},{40,60}})),                                     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},{40,60}})),
    experiment(StopTime=31536000, __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="Examples/Simulate and Plot.mos" "Simulate and Plot",
        file="Examples/Simulate.mos" "Simulate"));
end Latest;
