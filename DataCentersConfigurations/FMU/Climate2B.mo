within DataCentersConfigurations.FMU;
model Climate2B
parameter Real TAirset = 273.15 + 18 "[K]";
  parameter Real TFreeze=273.15 + 3 "[K]";
  parameter Real TCWsupset = 273.15 + 8 "[K]";
  parameter Real TAppNominal = 6 "[K]";
  parameter Real ITLoad = 500000 "[W]";
parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=ITLoad/(
      1005*15) "Nominal mass flow rate at fan";
  parameter Modelica.Units.SI.Power P_nominal=80E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal=5*ITLoad/(
      4200*20) "Nominal mass flow rate at chilled water";

  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal=3*ITLoad/(
      4200*6) "Nominal mass flow rate at condenser water";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=500
    "Nominal pressure difference";
  replaceable DataCentersConfigurations.Architecture.DataCenter dataCenter(
    mAir_flow_nominal=mAir_flow_nominal,
    P_nominal=P_nominal,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    COPc_nominal=COPc_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    dp_nominal=dp_nominal,
    TApp_nominal=TAppNominal)
    annotation (Placement(transformation(extent={{18,-24},{48,22}})));
  Controls.TrimandResponse.Control control(
    TAirset=TAirset,
    TFreeze=TFreeze,
    TCWsupset=TCWsupset,
    ITLoad=ITLoad,
    TAppNominal=TAppNominal,
    mAir_flow_nominal=mAir_flow_nominal,
    P_nominal=P_nominal,
    dTEva_nominal=dTEva_nominal,
    dTCon_nominal=dTCon_nominal,
    COPc_nominal=COPc_nominal,
    mCHW_flow_nominal=mCHW_flow_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-54,-26},{-20,24}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaData(filNam=
        "D:/Github/DataCenterArchitecture/weather/2B.mos")
    annotation (Placement(transformation(extent={{-34,40},{-54,60}})));
  Modelica.Blocks.Interfaces.RealInput architecture
    annotation (Placement(transformation(extent={{-122,-22},{-82,20}})));
equation
  connect(dataCenter.Temperature, control.Temperature) annotation (Line(
      points={{48.2,0},{52,0},{52,-36},{-37,-36},{-37,-22.25}},
      color={255,204,51},
      thickness=0.5));
  connect(weaData.weaBus, control.weaBus) annotation (Line(
      points={{-54,50},{-64,50},{-64,18.5833},{-54,18.5833}},
      color={255,204,51},
      thickness=0.5));
  connect(control.Control, dataCenter.Control) annotation (Line(
      points={{-19.66,-0.58333},{-19.66,-0.2},{18.2,-0.2}},
      color={255,204,51},
      thickness=0.5));
  connect(architecture, control.u)
    annotation (Line(points={{-102,-1},{-55.02,-1}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=86400, __Dymola_Algorithm="Dassl"));
end Climate2B;
