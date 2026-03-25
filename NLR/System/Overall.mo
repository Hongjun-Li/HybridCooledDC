within NLR.System;
model Overall
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=roo.QRoo_flow/(
      1005*15) "Nominal mass flow rate at fan";
  parameter  Modelica.Units.SI.Power P_nominal=80E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal=8 "Chiller COP";
  parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal=24.23 "Nominal mass flow rate at chilled water";

  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal=30.28 "Nominal mass flow rate at condenser water";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=500
    "Nominal pressure difference";
  parameter Real TApp_nominal = 6 "K";

// Dry Cooling Tower
  parameter Modelica.Units.SI.Temperature T_a1_nominal=30 + 273.15
    "Temperature at nominal conditions as port a1";
  parameter Modelica.Units.SI.Temperature T_b1_nominal=10 + 273.15
    "Temperature at nominal conditions as port b1";
  parameter Modelica.Units.SI.Temperature T_a2_nominal=10 + 273.15
    "Temperature at nominal conditions as port a2";
  parameter Modelica.Units.SI.Temperature T_b2_nominal=30 + 273.15
    "Temperature at nominal conditions as port b2";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=mCW_flow_nominal
    "Nominal mass flow rate medium 1";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=m1_flow_nominal*4200
      /1000*(T_a1_nominal - T_b1_nominal)/(T_b2_nominal - T_a2_nominal)
    "Nominal mass flow rate medium 2";
  Equipment.AHU AHU(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction", redeclare package
      Medium2 = Buildings.Media.Air "Moist air",
    m1_flow_nominal=mCHW_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal)
    annotation (Placement(transformation(extent={{-60,-44},{-40,-24}})));
  Equipment.SimplifiedRoom simplifiedRoom(redeclare package Medium = MediumA,
    rooLen=50,
    rooWid=30,
    rooHei=3,
    QRoo_flow=500000,
    m_flow_nominal=mAir_flow_nominal,     nPorts=2)
    annotation (Placement(transformation(extent={{-60,-84},{-40,-64}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare replaceable
      package Medium = Buildings.Media.Air "Moist air", m_flow_nominal=
        mAir_flow_nominal) "Supply air temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-64})));
  Equipment.CT WCT(redeclare package Medium = Buildings.Media.Water "Water",
    m_flow_nominal=mCW_flow_nominal,
    dp_nominal=14930 + 14930 + 74650,
    TAirInWB_nominal=283.15,
    PFan_nominal=6000,
    TApp_nominal=TApp_nominal)
    annotation (Placement(transformation(extent={{10,76},{-10,96}})));
  Equipment.WSE WSE(redeclare package Medium1 = Buildings.Media.Water "Water",
      redeclare package Medium2 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction",
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,16},{10,36}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup(redeclare replaceable
      package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        mCHW_flow_nominal) "Supply Fluid temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,-64})));
  Equipment.D2C D2C
    annotation (Placement(transformation(extent={{40,-84},{60,-64}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear thrWayVal(
    redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    final from_dp=from_dp2,
    final linearized={linearizeFlowResistance2,linearizeFlowResistance2},
    final rhoStd=rhoStd,
    final homotopyInitialization=homotopyInitialization,
    final use_strokeTime=use_strokeTime,
    final strokeTime=strokeTime,
    final init=init,
    final R=R,
    final delta0=delta0,
    final fraK=fraK_ThrWayVal,
    final dpFixed_nominal={dp2_nominal,0},
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final X_start=X_start,
    final y_start=yThrWayVal_start,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final l=l_ThrWayVal,
    final dpValve_nominal=dpValve_nominal,
    final deltaM=deltaM2,
    final m_flow_nominal=m2_flow_nominal,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3,
    final tau=tauThrWayVal) if activate_ThrWayVal
    "Three-way valve used to control the outlet temperature "
    annotation (Placement(transformation(extent={{-10,-18},{10,-38}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup(redeclare replaceable
      package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction", m_flow_nominal=
        mCHW_flow_nominal)
    "Supply CHW temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(redeclare replaceable
      package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction", m_flow_nominal=
        mCHW_flow_nominal)
    "Return CHW temperature" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,0})));
  Equipment.CDU CDU(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction", redeclare package
      Medium2 = Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,
          X_a=0.40) "Propylene glycol water, 40% mass fraction",
    m1_flow_nominal=mCHW_flow_nominal,
    m2_flow_nominal=15,
    dp1_nominal=6000,
    dp2_nominal=249*3,
    UA_nominal=15*4186*5)
    annotation (Placement(transformation(extent={{40,-44},{60,-24}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = Buildings.Media.Water "Water",
    m_flow_nominal=mCW_flow_nominal,
    dp(start=214992),
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=130000) "Condenser water pump" annotation (Placement(
        transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-40,86})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(redeclare replaceable
      package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        mCW_flow_nominal)
    "Supply CW temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(redeclare replaceable
      package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        mCW_flow_nominal)
    "Return CW temperature" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,50})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear MainValve(
    redeclare package Medium = Buildings.Media.Water "Water",
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={32,86})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear Bypass(
    redeclare package Medium = Buildings.Media.Water "Water",
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={0,60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirRet(redeclare replaceable
      package Medium = Buildings.Media.Air "Moist air", m_flow_nominal=
        mAir_flow_nominal) "Return air temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-64})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDURet(redeclare replaceable
      package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        mCHW_flow_nominal) "Return CDU temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-64})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus controlBus
    annotation (Placement(transformation(extent={{-144,-28},{-96,20}}),
        iconTransformation(extent={{-134,-18},{-96,20}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{90,-26},{138,22}}),
        iconTransformation(extent={{100,-16},{138,22}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus ITProfile
    annotation (Placement(transformation(extent={{-140,-130},{-100,-90}}),
        iconTransformation(extent={{-140,-110},{-102,-72}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCDU(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel" annotation (Placement(
        transformation(
        extent={{-6,7},{6,-7}},
        rotation=90,
        origin={111,-40})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{-6,7},{6,-7}},
        rotation=90,
        origin={111,-28})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCW(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel" annotation (Placement(
        transformation(
        extent={{-6,7},{6,-7}},
        rotation=90,
        origin={111,32})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCHW(
    redeclare package Medium = Buildings.Media.Water "Water",
    m_flow_nominal=mCHW_flow_nominal,
    dp(start=214992),
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=130000) "Chilled water pump"   annotation (Placement(
        transformation(
        extent={{8,8},{-8,-8}},
        rotation=0,
        origin={-40,20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUEnt(redeclare replaceable
      package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        mCHW_flow_nominal) "Supply Fluid temperature" annotation (Placement(
        transformation(
        extent={{5,6},{-5,-6}},
        rotation=180,
        origin={25,-28})));
equation
  connect(AHU.port_b2, TAirSup.port_a) annotation (Line(
      points={{-60,-40},{-80,-40},{-80,-54}},
      color={28,108,200},
      thickness=0.5));
  connect(TAirSup.port_b, simplifiedRoom.airPorts[1]) annotation (Line(
      points={{-80,-74},{-80,-88},{-50.5625,-88},{-50.5625,-82.7}},
      color={28,108,200},
      thickness=0.5));
  connect(TCDUSup.port_b, D2C.port_a) annotation (Line(
      points={{20,-74},{20,-88},{48.75,-88},{48.75,-84}},
      color={28,108,200},
      thickness=0.5));
  connect(AHU.port_b1, thrWayVal.port_1) annotation (Line(
      points={{-40,-28},{-10,-28}},
      color={238,46,47},
      thickness=0.5));
  connect(TCHWSup.port_b, AHU.port_a1) annotation (Line(
      points={{-80,-10},{-80,-28},{-60,-28}},
      color={28,108,200},
      thickness=0.5));
  connect(WSE.port_a2, TCHWRet.port_a) annotation (Line(
      points={{10,20},{80,20},{80,10}},
      color={238,46,47},
      thickness=0.5));
  connect(thrWayVal.port_3, AHU.port_a1) annotation (Line(
      points={{0,-18},{0,-14},{-80,-14},{-80,-28},{-60,-28}},
      color={28,108,200},
      thickness=0.5));
  connect(CDU.port_b1, TCHWRet.port_b) annotation (Line(
      points={{60,-28},{80,-28},{80,-10}},
      color={238,46,47},
      thickness=0.5));
  connect(CDU.port_b2, TCDUSup.port_a) annotation (Line(
      points={{40,-40},{20,-40},{20,-54}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCW.port_a, WCT.port_b) annotation (Line(
      points={{-32,86},{-10,86}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCW.port_b, TCWSup.port_a) annotation (Line(
      points={{-48,86},{-80,86},{-80,60}},
      color={28,108,200},
      thickness=0.5));
  connect(TCWSup.port_b, WSE.port_a1) annotation (Line(
      points={{-80,40},{-80,32},{-10,32}},
      color={28,108,200},
      thickness=0.5));
  connect(WSE.port_b1, TCWRet.port_b) annotation (Line(
      points={{10,32},{80,32},{80,40}},
      color={238,46,47},
      thickness=0.5));
  connect(WCT.port_a, MainValve.port_b) annotation (Line(
      points={{10,86},{26,86}},
      color={238,46,47},
      thickness=0.5));
  connect(MainValve.port_a, TCWRet.port_a) annotation (Line(
      points={{38,86},{80,86},{80,60}},
      color={238,46,47},
      thickness=0.5));
  connect(Bypass.port_a, TCWRet.port_a) annotation (Line(
      points={{6,60},{80,60}},
      color={238,46,47},
      thickness=0.5));
  connect(Bypass.port_b, TCWSup.port_a) annotation (Line(
      points={{-6,60},{-80,60}},
      color={28,108,200},
      thickness=0.5));
  connect(TAirRet.port_b, simplifiedRoom.airPorts[2]) annotation (Line(
      points={{-20,-74},{-20,-88},{-48.5375,-88},{-48.5375,-82.7}},
      color={238,46,47},
      thickness=0.5));
  connect(TAirRet.port_a, AHU.port_a2) annotation (Line(
      points={{-20,-54},{-20,-40},{-40,-40}},
      color={238,46,47},
      thickness=0.5));
  connect(D2C.port_b, TCDURet.port_b) annotation (Line(
      points={{51.25,-84},{52,-84},{52,-88},{80,-88},{80,-74}},
      color={238,46,47},
      thickness=0.5));
  connect(TCDURet.port_a, CDU.port_a2) annotation (Line(
      points={{80,-54},{80,-40},{60,-40}},
      color={238,46,47},
      thickness=0.5));
  connect(TCWSup.T, Temperature.TCWSup) annotation (Line(
      points={{-91,50},{-100,50},{-100,110},{100,110},{100,-2},{114,-2}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCWRet.T, Temperature.TCWRet) annotation (Line(
      points={{91,50},{100,50},{100,-2},{114,-2}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCHWSup.T, Temperature.TCHWSup) annotation (Line(
      points={{-91,0},{-100,0},{-100,110},{100,110},{100,-2},{114,-2}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCHWRet.T, Temperature.TCHWRet) annotation (Line(
      points={{91,0},{106,0},{106,-2},{114,-2}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TAirSup.T, Temperature.TAirSup) annotation (Line(
      points={{-91,-64},{-100,-64},{-100,-100},{100,-100},{100,-2},{114,-2}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TAirRet.T, Temperature.TAirRet) annotation (Line(
      points={{-9,-64},{-4,-64},{-4,-100},{100,-100},{100,-2},{114,-2}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCDUSup.T, Temperature.TCDUSup) annotation (Line(
      points={{9,-64},{4,-64},{4,-100},{100,-100},{100,-2},{114,-2}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCDURet.T, Temperature.TCDURet) annotation (Line(
      points={{91,-64},{100,-64},{100,-2},{114,-2}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(controlBus.ValveMix, thrWayVal.y) annotation (Line(
      points={{-120,-4},{-120,-120},{0,-120},{0,-40}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(controlBus.AHUValve, AHU.uVal) annotation (Line(
      points={{-120,-4},{-120,-30},{-61,-30}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(controlBus.AHUXSet, AHU.XSet_w) annotation (Line(
      points={{-120,-4},{-120,-33},{-61,-33}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(controlBus.TAirSupSet, AHU.TSet) annotation (Line(
      points={{-120,-4},{-120,-35},{-61,-35}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(controlBus.AHUFan, AHU.uFan) annotation (Line(
      points={{-120,-4},{-120,-38},{-61,-38}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(controlBus, controlBus) annotation (Line(
      points={{-120,-4},{-120,-4}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.CWBypass, Bypass.y) annotation (Line(
      points={{-120,-4},{-120,70},{0,70},{0,67.2}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(controlBus.PumpCW, pumCW.m_flow_in) annotation (Line(
      points={{-120,-4},{-120,104},{-40,104},{-40,95.6}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(controlBus.CTFan, WCT.y) annotation (Line(
      points={{-120,-4},{-120,108},{20,108},{20,94},{12,94}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(controlBus.ValveWCT, MainValve.y) annotation (Line(
      points={{-120,-4},{-120,70},{32,70},{32,78.8}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(ITProfile.ITLoadAir, simplifiedRoom.u) annotation (Line(
      points={{-120,-110},{-70,-110},{-70,-74},{-60,-74}},
      color={217,67,180},
      pattern=LinePattern.Dash));
  connect(ITProfile.ITLoadCDU, D2C.u) annotation (Line(
      points={{-120,-110},{32,-110},{32,-73.9375},{39.75,-73.9375}},
      color={217,67,180},
      pattern=LinePattern.Dash));
  connect(expVesCDU.port_a, CDU.port_a2) annotation (Line(
      points={{104,-40},{60,-40}},
      color={238,46,47},
      thickness=0.5));
  connect(expVesCHW.port_a, TCHWRet.port_b) annotation (Line(
      points={{104,-28},{80,-28},{80,-10}},
      color={238,46,47},
      thickness=0.5));
  connect(expVesCW.port_a, TCWRet.port_b) annotation (Line(
      points={{104,32},{80,32},{80,40}},
      color={238,46,47},
      thickness=0.5));
  connect(pumCHW.port_a, WSE.port_b2) annotation (Line(
      points={{-32,20},{-10,20}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCHW.port_b, TCHWSup.port_a) annotation (Line(
      points={{-48,20},{-80,20},{-80,10}},
      color={28,108,200},
      thickness=0.5));
  connect(controlBus.PumpCHW, pumCHW.m_flow_in) annotation (Line(
      points={{-120,-4},{-120,10.4},{-40,10.4}},
      color={255,204,51},
      pattern=LinePattern.Dash));
  connect(TCDUEnt.port_b, CDU.port_a1) annotation (Line(
      points={{30,-28},{40,-28}},
      color={244,125,35},
      thickness=0.5));
  connect(TCDUEnt.port_a, thrWayVal.port_2) annotation (Line(
      points={{20,-28},{10,-28}},
      color={244,125,35},
      thickness=0.5));
  connect(TCDUEnt.T, Temperature.TCDUEnt) annotation (Line(
      points={{25,-21.4},{25,-16},{100,-16},{100,-2},{114,-2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},
            {120,120}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end Overall;
