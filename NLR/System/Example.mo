within NLR.System;
model Example
  Equipment.CoolingCoilHumidifyingHeating AHU
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Equipment.SimplifiedRoom simplifiedRoom(nPorts=2)
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare replaceable
      package Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-60})));
  Equipment.YorkCalc yorkCalc
    annotation (Placement(transformation(extent={{10,80},{-10,100}})));
  Equipment.ConstantEffectiveness hex
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup(redeclare replaceable
      package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction", m_flow_nominal=
        mAir_flow_nominal) "Supply Fluid temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,-60})));
  Equipment.D2C d2C
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear thrWayVal(
    redeclare package Medium = Medium2,
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
    annotation (Placement(transformation(extent={{-10,-14},{10,-34}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup(redeclare replaceable
      package Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
    "Supply CHW temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,4})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(redeclare replaceable
      package Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
    "Return CHW temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,4})));
  Buildings.Fluid.Movers.FlowControlled_dp pumCHW(
    redeclare package Medium = Buildings.Media.Water "Water",
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=130000)
    annotation (Placement(transformation(extent={{-32,32},{-48,16}})));
  Equipment.DryCoilCounterFlow heaCoi
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=214992),
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=130000) "Condenser water pump" annotation (Placement(
        transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-40,90})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup1(redeclare replaceable
      package Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
    "Supply CHW temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,50})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup2(redeclare replaceable
      package Medium = MediumA, m_flow_nominal=mAir_flow_nominal)
    "Supply CHW temperature" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,50})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear MainValve(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={32,90})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear Bypass(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={0,64})));
equation
  connect(AHU.port_b2, TAirSup.port_a) annotation (Line(points={{-60,-36},{-80,
          -36},{-80,-50}}, color={0,127,255}));
  connect(TAirSup.port_b, simplifiedRoom.airPorts[1]) annotation (Line(points={
          {-80,-70},{-80,-84},{-50.5625,-84},{-50.5625,-78.7}}, color={0,127,
          255}));
  connect(simplifiedRoom.airPorts[2], AHU.port_a2) annotation (Line(points={{
          -48.5375,-78.7},{-48.5375,-84},{-20,-84},{-20,-36},{-40,-36}}, color=
          {0,127,255}));
  connect(TCDUSup.port_b, d2C.port_a) annotation (Line(points={{20,-70},{20,-84},
          {48.75,-84},{48.75,-80}}, color={0,127,255}));
  connect(AHU.port_b1, thrWayVal.port_1)
    annotation (Line(points={{-40,-24},{-10,-24}}, color={0,127,255}));
  connect(TCHWSup.port_b, AHU.port_a1) annotation (Line(points={{-80,-6},{-80,
          -24},{-60,-24}}, color={0,127,255}));
  connect(pumCHW.port_a, hex.port_b2)
    annotation (Line(points={{-32,24},{-10,24}}, color={0,127,255}));
  connect(pumCHW.port_b, TCHWSup.port_a)
    annotation (Line(points={{-48,24},{-80,24},{-80,14}}, color={0,127,255}));
  connect(hex.port_a2, TCHWRet.port_a)
    annotation (Line(points={{10,24},{80,24},{80,14}}, color={0,127,255}));
  connect(thrWayVal.port_3, AHU.port_a1) annotation (Line(points={{0,-14},{0,
          -10},{-80,-10},{-80,-24},{-60,-24}}, color={0,127,255}));
  connect(thrWayVal.port_2, heaCoi.port_a1)
    annotation (Line(points={{10,-24},{40,-24}}, color={0,127,255}));
  connect(heaCoi.port_b1, TCHWRet.port_b)
    annotation (Line(points={{60,-24},{80,-24},{80,-6}}, color={0,127,255}));
  connect(heaCoi.port_b2, TCDUSup.port_a)
    annotation (Line(points={{40,-36},{20,-36},{20,-50}}, color={0,127,255}));
  connect(heaCoi.port_a2, d2C.port_b) annotation (Line(points={{60,-36},{80,-36},
          {80,-84},{51.25,-84},{51.25,-80}}, color={0,127,255}));
  connect(pumCW.port_a, yorkCalc.port_b)
    annotation (Line(points={{-32,90},{-10,90}}, color={0,127,255}));
  connect(pumCW.port_b, TCHWSup1.port_a)
    annotation (Line(points={{-48,90},{-80,90},{-80,60}}, color={0,127,255}));
  connect(TCHWSup1.port_b, hex.port_a1)
    annotation (Line(points={{-80,40},{-80,36},{-10,36}}, color={0,127,255}));
  connect(hex.port_b1, TCHWSup2.port_b)
    annotation (Line(points={{10,36},{80,36},{80,40}}, color={0,127,255}));
  connect(yorkCalc.port_a, MainValve.port_b)
    annotation (Line(points={{10,90},{26,90}}, color={0,127,255}));
  connect(MainValve.port_a, TCHWSup2.port_a)
    annotation (Line(points={{38,90},{80,90},{80,60}}, color={0,127,255}));
  connect(Bypass.port_a, TCHWSup2.port_a)
    annotation (Line(points={{6,64},{80,64},{80,60}}, color={0,127,255}));
  connect(Bypass.port_b, TCHWSup1.port_a)
    annotation (Line(points={{-6,64},{-80,64},{-80,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Example;
