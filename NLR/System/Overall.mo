within NLR.System;
model Overall
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";
  Equipment.AHU AHU(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction", redeclare package
      Medium2 = Buildings.Media.Air "Moist air")
    annotation (Placement(transformation(extent={{-60,-44},{-40,-24}})));
  Equipment.SimplifiedRoom simplifiedRoom(redeclare package Medium = MediumA,
                                          nPorts=2)
    annotation (Placement(transformation(extent={{-60,-84},{-40,-64}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare replaceable
      package Medium = Buildings.Media.Air "Moist air", m_flow_nominal=
        mAir_flow_nominal) "Supply air temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-64})));
  Equipment.CT WCT(redeclare package Medium = Buildings.Media.Water "Water")
    annotation (Placement(transformation(extent={{10,76},{-10,96}})));
  Equipment.WSE WSE(redeclare package Medium1 = Buildings.Media.Water "Water",
      redeclare package Medium2 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction")
    annotation (Placement(transformation(extent={{-10,16},{10,36}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup(redeclare replaceable
      package Medium = Buildings.Media.Water "Water",
                                                   m_flow_nominal=
        mAir_flow_nominal) "Supply Fluid temperature" annotation (Placement(
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
      "Propylene glycol water, 40% mass fraction",
                                m_flow_nominal=mAir_flow_nominal)
    "Supply CHW temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(redeclare replaceable
      package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
                                m_flow_nominal=mAir_flow_nominal)
    "Return CHW temperature" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,0})));
  Buildings.Fluid.Movers.FlowControlled_dp pumCHW(
    redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=130000)
    annotation (Placement(transformation(extent={{-32,28},{-48,12}})));
  Equipment.CDU CDU(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction", redeclare package
      Medium2 = Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=
            293.15, X_a=0.40) "Propylene glycol water, 40% mass fraction")
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
      package Medium = Buildings.Media.Water "Water",
                                m_flow_nominal=mAir_flow_nominal)
    "Supply CW temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(redeclare replaceable
      package Medium = Buildings.Media.Water "Water",
                                m_flow_nominal=mAir_flow_nominal)
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
      package Medium = Buildings.Media.Water "Water",
                                                   m_flow_nominal=
        mAir_flow_nominal) "Return CDU temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-64})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus controlBus
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-130,-10},{-110,10}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{110,-10},{130,10}})));
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
  connect(pumCHW.port_a, WSE.port_b2) annotation (Line(
      points={{-32,20},{-10,20}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCHW.port_b, TCHWSup.port_a) annotation (Line(
      points={{-48,20},{-80,20},{-80,10}},
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
  connect(thrWayVal.port_2, CDU.port_a1) annotation (Line(
      points={{10,-28},{40,-28}},
      color={244,125,35},
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
      points={{-91,50},{-100,50},{-100,110},{100,110},{100,0},{120,0}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCWRet.T, Temperature.TCWRet) annotation (Line(
      points={{91,50},{100,50},{100,0},{120,0}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCHWSup.T, Temperature.TCHWSup) annotation (Line(
      points={{-91,0},{-100,0},{-100,110},{100,110},{100,0},{120,0}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCHWRet.T, Temperature.TCHWRet) annotation (Line(
      points={{91,0},{120,0}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TAirSup.T, Temperature.TAirSup) annotation (Line(
      points={{-91,-64},{-100,-64},{-100,-100},{100,-100},{100,0},{120,0}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TAirRet.T, Temperature.TAirRet) annotation (Line(
      points={{-9,-64},{-4,-64},{-4,-100},{100,-100},{100,0},{120,0}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCDUSup.T, Temperature.TCDUSup) annotation (Line(
      points={{9,-64},{4,-64},{4,-100},{100,-100},{100,0},{120,0}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(TCDURet.T, Temperature.TCDURet) annotation (Line(
      points={{91,-64},{100,-64},{100,0},{120,0}},
      color={0,0,0},
      pattern=LinePattern.Dash));
  connect(controlBus.ValveMix, thrWayVal.y) annotation (Line(
      points={{-120,0},{-120,-120},{0,-120},{0,-40}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.AHUValve, AHU.uVal) annotation (Line(
      points={{-120,0},{-120,-30},{-61,-30}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.AHUXSet, AHU.XSet_w) annotation (Line(
      points={{-120,0},{-120,-33},{-61,-33}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.TAirSupSet, AHU.TSet) annotation (Line(
      points={{-120,0},{-120,-35},{-61,-35}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.AHUFan, AHU.uFan) annotation (Line(
      points={{-120,0},{-120,-38},{-61,-38}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus, controlBus) annotation (Line(
      points={{-120,0},{-120,0}},
      color={255,204,51},
      thickness=0.5));
  connect(controlBus.PumpCHW, pumCHW.dp_in) annotation (Line(
      points={{-120,0},{-120,6},{-40,6},{-40,10.4}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.CWBypass, Bypass.y) annotation (Line(
      points={{-120,0},{-120,70},{0,70},{0,67.2}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.PumpCW, pumCW.m_flow_in) annotation (Line(
      points={{-120,0},{-120,104},{-40,104},{-40,95.6}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.CTFan, WCT.y) annotation (Line(
      points={{-120,0},{-120,108},{20,108},{20,94},{12,94}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(controlBus.ValveWCT, MainValve.y) annotation (Line(
      points={{-120,0},{-120,70},{32,70},{32,78.8}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})));
end Overall;
