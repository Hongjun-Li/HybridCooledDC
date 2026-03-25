within DataCentersConfigurations.Architecture;
model DataCenter "Primary only chiller plant system with water-side economizer"
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
  parameter Real COC = 5 "Cycles of Concentration";
  parameter Real Drift = 0.001 "Drift Loss [fraction of RR, e.g., 0.1% = 0.001]";
  parameter Real Eva_Factor = 0.85 "Evaporation Factor";

  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    addPowerToMedium=false,
    m_flow_nominal=mAir_flow_nominal,
    dp(start=249),
    m_flow(start=mAir_flow_nominal),
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=293.15,
    dp_nominal=750) "Fan for air flow through the data center"
    annotation (Placement(transformation(extent={{5.5,-6},{-5.5,6}},
        rotation=90,
        origin={140,-11.5})));
  ChillerPlant.BaseClasses.SimplifiedRoom roo(
    redeclare package Medium = MediumA,
    rooLen=50,
    rooWid=30,
    rooHei=3,
    m_flow_nominal=mAir_flow_nominal,
    QRoo_flow=500000,
    nPorts=2) "Room model" annotation (Placement(transformation(extent={{-10,10},
            {10,-10}}, origin={180,-42})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{-6,7},{6,-7}},
        rotation=90,
        origin={313,24})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    PFan_nominal=6000,
    TAirInWB_nominal(displayUnit="degC") = 283.15,
    TApp_nominal=TApp_nominal,
    dp_nominal=14930 + 14930 + 74650,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling tower"                                   annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={207,239})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dp(start=214992),
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=130000) "Condenser water pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={140,180})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness wse(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    eps=0.8,
    dp2_nominal=0,
    dp1_nominal=0) "Water side economizer (Heat exchanger)"
    annotation (Placement(transformation(extent={{234,99},{254,119}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=0,
        origin={271,137})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    use_strokeTime=false,
    dpFixed_nominal=59720 + 1000)
    "Bypass control valve for economizer. 1: disable economizer, 0: enable economoizer"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={280,90})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_PEH_1104kW_8_00COP_Vanes(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{160,99},{180,119}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val6(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=14930 + 89580,
    y_start=1,
    use_strokeTime=false,
    from_dp=true)
    "Control valve for chilled water leaving from chiller" annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=270,
        origin={140,90})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=59720,
    y_start=0,
    use_strokeTime=false)
    "Control valve for condenser water loop of economizer" annotation (
      Placement(transformation(
        extent={{-5,5},{5,-5}},
        rotation=0,
        origin={267,115})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirSup(redeclare package Medium =
        MediumA, m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature to data center" annotation (Placement(
        transformation(
        extent={{-4,-4.5},{4,4.5}},
        origin={160,-27.5})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEntChi(redeclare package
      Medium = MediumW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water entering chiller" annotation (Placement(
        transformation(
        extent={{-5,-6},{5,6}},
        rotation=0,
        origin={207,72})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower" annotation (
      Placement(transformation(
        extent={{7,6},{-7,-6}},
        origin={140,153},
        rotation=90)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage ChiBypass(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=14930,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(extent={{5,-6},{-5,6}}, origin={171,72})));
  Modelica.Blocks.Sources.RealExpression PHVAC(y=fan.P + pumCHW.P + pumCW.P +
        cooTow.PFan + chi.P + DCTFan.P + d2C.pum.P)
    "Power consumed by HVAC system"
                             annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={276,-72})));
  Modelica.Blocks.Continuous.Integrator EHVAC(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by HVAC"
    annotation (Placement(transformation(extent={{310,-82},{330,-62}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWret(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower" annotation (
      Placement(transformation(
        extent={{6.5,6},{-6.5,-6}},
        origin={280,165.5},
        rotation=90)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=0,
        origin={208,210})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val7(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=0,
        origin={243,239})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage WSEBypass(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(extent={{5,-6},{-5,6}}, origin={245,72})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWret(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water leaving the cooling coil" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={280,50})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m2_flow_nominal=mAir_flow_nominal,
    m1_flow_nominal=mCHW_flow_nominal,
    m1_flow(start=mCHW_flow_nominal),
    m2_flow(start=mAir_flow_nominal),
    dp2_nominal=249*3,
    UA_nominal=mAir_flow_nominal*1006*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp1_nominal(displayUnit="Pa") = 1000 + 89580) "Cooling coil"
    annotation (Placement(transformation(extent={{186,10},{202,26}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWsup(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water leaving the cooling coil" annotation (
      Placement(transformation(
        extent={{-6,-7},{6,7}},
        rotation=0,
        origin={164,23})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCW(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel" annotation (Placement(
        transformation(
        extent={{-6,7},{6,-7}},
        rotation=90,
        origin={315,114})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{380,-20},{420,20}}),
        iconTransformation(extent={{392,50},{412,70}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Control
    annotation (Placement(transformation(extent={{82,-20},{122,20}}),
        iconTransformation(extent={{92,48},{112,68}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    show_T=true,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mAir_flow_nominal,
    use_Q_flow_nominal=false,
    Q_flow_nominal=m1_flow_nominal*4200*(T_a1_nominal - T_b1_nominal),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    dp1_nominal(displayUnit="Pa") = 0,
    dp2_nominal(displayUnit="Pa") = 200 + 100,
    eps_nominal=0.8)
    "Heat exchanger"
     annotation (Placement(transformation(extent={{216,280},{196,260}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{5,5},{-5,-5}},
        rotation=0,
        origin={243,265})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumA,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{136,284},{156,304}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = MediumA,
    use_T_in=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{266,280},{246,300}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow DCTFan(
    redeclare package Medium = MediumA,
    addPowerToMedium=false,
    m_flow_nominal=1.5*mAir_flow_nominal,
    dp(start=249),
    m_flow(start=1.5*mAir_flow_nominal),
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=293.15,
    dp_nominal=750) "Fan for air flow through the data center" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={174,293})));
  Modelica.Blocks.Math.Gain gain(k=1.5*mAir_flow_nominal)
    annotation (Placement(transformation(extent={{136,316},{156,336}})));
  Components.D2C d2C(v=20)
    annotation (Placement(transformation(extent={{232,-18},{248,-2}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal/5)
    "Supply CDU temperature to data center" annotation (Placement(
        transformation(
        extent={{-4,-4.5},{4,4.5}},
        origin={222,0.5},
        rotation=270)));
  Buildings.Fluid.Storage.ExpansionVessel expVesCDU(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel" annotation (Placement(
        transformation(
        extent={{-6,7},{6,-7}},
        rotation=90,
        origin={315,-8})));
  Modelica.Blocks.Sources.RealExpression PIT(y=500000)
    "Power consumed by HVAC system" annotation (Placement(transformation(extent
          ={{-10,-10},{10,10}}, origin={276,-100})));
  Modelica.Blocks.Continuous.Integrator EIT(initType=Modelica.Blocks.Types.Init.InitialState,
      y_start=0) "Energy consumed by IT"
    annotation (Placement(transformation(extent={{310,-110},{330,-90}})));
  Modelica.Blocks.Sources.RealExpression PUE(y=(PHVAC.y + PIT.y)/PIT.y) "PUE"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={278,-138})));
  Modelica.Blocks.Math.Gain gain1(k=mAir_flow_nominal)
    annotation (Placement(transformation(extent={{124,-14},{128,-10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage AHUValve(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=1,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(extent={{-5,-6},{5,6}}, origin={179,22})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage CDUValve(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=1,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "CDU Valve" annotation (Placement(transformation(extent={{-5,-6},
            {5,6}}, origin={179,44})));
  Buildings.Fluid.Movers.FlowControlled_dp pumCHW(
    redeclare package Medium = Buildings.Media.Water "Water",
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=130000)
    annotation (Placement(transformation(extent={{146,18},{156,28}})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow CDU(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = Buildings.Media.Water "Water",
    m2_flow_nominal=15,
    m1_flow_nominal=mCHW_flow_nominal,
    m1_flow(start=mCHW_flow_nominal),
    m2_flow(start=15),
    dp2_nominal=249*3,
    UA_nominal=15*4186*5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp1_nominal(displayUnit="Pa") = 6000) "Cooling coil"
    annotation (Placement(transformation(extent={{228,10},{244,26}})));
  Metrics.Water water(
    RR=mCW_flow_nominal,
    COC=COC,
    Drift=Drift,
    Eva_Factor=Eva_Factor)
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  Modelica.Blocks.Sources.RealExpression WUE(y=water.y/((PHVAC.y + PIT.y)/1000))
    "WUE" annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          origin={284,-164})));
equation

  connect(PHVAC.y, EHVAC.u) annotation (Line(
      points={{287,-72},{308,-72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumCW.port_a, cooTow.port_b) annotation (Line(points={{140,190},{140,239},
          {197,239}}, color={0,127,255}));
  connect(wse.port_b1, val4.port_a)
    annotation (Line(points={{254,115},{262,115}}, color={0,127,255}));
  connect(val5.port_a, chi.port_b1) annotation (Line(points={{266,137},{202,137},
          {202,115},{180,115}}, color={0,127,255}));
  connect(TCWSup.port_a, pumCW.port_b)
    annotation (Line(points={{140,160},{140,170}}, color={0,127,255}));
  connect(TCWSup.port_b, chi.port_a1) annotation (Line(points={{140,146},{140,115},
          {160,115}}, color={0,127,255}));
  connect(TCWSup.port_b, wse.port_a1) annotation (Line(points={{140,146},{140,132},
          {232,132},{232,115},{234,115}}, color={0,127,255}));
  connect(TCWret.port_b, val4.port_b) annotation (Line(points={{280,159},{280,115},
          {272,115}}, color={0,127,255}));
  connect(val2.port_b, cooTow.port_b) annotation (Line(points={{204,210},{140,210},
          {140,239},{197,239}}, color={0,127,255}));
  connect(cooTow.port_a, val7.port_b)
    annotation (Line(points={{217,239},{238,239}}, color={0,127,255}));
  connect(val7.port_a, TCWret.port_a) annotation (Line(points={{248,239},{280,239},
          {280,172}}, color={0,127,255}));
  connect(val2.port_a, TCWret.port_a) annotation (Line(points={{212,210},{280,210},
          {280,172}}, color={0,127,255}));
  connect(TCHWEntChi.port_b, wse.port_b2) annotation (Line(points={{212,72},{216,
          72},{216,103},{234,103}}, color={0,127,255}));
  connect(WSEBypass.port_b, wse.port_b2) annotation (Line(points={{240,72},{216,
          72},{216,103},{234,103}}, color={0,127,255}));
  connect(val6.port_b, chi.port_b2) annotation (Line(points={{140,96},{140,103},
          {160,103}}, color={0,127,255}));
  connect(val6.port_a, ChiBypass.port_b)
    annotation (Line(points={{140,84},{140,72},{166,72}}, color={0,127,255}));
  connect(ChiBypass.port_a, chi.port_a2) annotation (Line(points={{176,72},{200,
          72},{200,103},{180,103}}, color={0,127,255}));
  connect(TCHWEntChi.port_a, chi.port_a2) annotation (Line(points={{202,72},{200,
          72},{200,103},{180,103}}, color={0,127,255}));
  connect(wse.port_a2, val1.port_b) annotation (Line(points={{254,103},{280,103},
          {280,96}}, color={0,127,255}));
  connect(val1.port_a, WSEBypass.port_a)
    annotation (Line(points={{280,84},{280,72},{250,72}}, color={0,127,255}));
  connect(val5.port_b, val4.port_b) annotation (Line(points={{276,137},{280,137},
          {280,115},{272,115}}, color={0,127,255}));
  connect(TCHWret.port_b, WSEBypass.port_a)
    annotation (Line(points={{280,60},{280,72},{250,72}}, color={0,127,255}));
  connect(expVesCHW.port_a, TCHWret.port_a)
    annotation (Line(points={{306,24},{280,24},{280,40}}, color={0,127,255}));
  connect(expVesCW.port_a, val4.port_b) annotation (Line(points={{308,114},{280,
          114},{280,115},{272,115}}, color={0,127,255}));
  connect(fan.port_a, cooCoi.port_b2)
    annotation (Line(points={{140,-6},{140,10},{186,10},{186,13.2}},
                                                         color={0,127,255}));
  connect(TAirSup.port_a, fan.port_b) annotation (Line(points={{156,-27.5},{140,
          -27.5},{140,-17}}, color={0,127,255}));
  connect(TAirSup.port_b, roo.airPorts[1]) annotation (Line(points={{164,-27.5},
          {178,-27.5},{178,-32},{179.438,-32},{179.438,-33.3}}, color={0,127,255}));
  connect(cooCoi.port_a2, roo.airPorts[2]) annotation (Line(points={{202,13.2},
          {204,13.2},{204,-28},{181.462,-28},{181.462,-33.3}},
        color={0,127,255}));
  connect(TCWSup.T, Temperature.TCWSup) annotation (Line(
      points={{146.6,153},{374,153},{374,0},{400,0}},
      color={0,0,127},
      pattern=LinePattern.Dot), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TCWret.T, Temperature.TCWRet) annotation (Line(
      points={{286.6,165.5},{374,165.5},{374,0},{400,0}},
      color={0,0,127},
      pattern=LinePattern.Dot), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TCHWsup.T, Temperature.TCHWSup) annotation (Line(
      points={{164,30.7},{164,42},{374,42},{374,0},{400,0}},
      color={0,0,127},
      pattern=LinePattern.Dot), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TCHWret.T, Temperature.TCHWRet) annotation (Line(
      points={{291,50},{374,50},{374,0},{400,0}},
      color={0,0,127},
      pattern=LinePattern.Dot), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(TAirSup.T, Temperature.TAirSup) annotation (Line(
      points={{160,-22.55},{160,-22},{374,-22},{374,0},{400,0}},
      color={0,0,127},
      pattern=LinePattern.Dot), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(Control.CTFan, cooTow.y) annotation (Line(
      points={{102,0},{102,-2},{104,-2},{104,2},{102,2},{102,254},{230,254},{230,
          246},{219,246},{219,247}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(Control.ValveWCT, val7.y) annotation (Line(
      points={{102,0},{102,224},{243,224},{243,233}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(Control.CWBypass, val2.y) annotation (Line(
      points={{102,0},{102,198},{208,198},{208,205.2}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(Control.PumpCW, pumCW.m_flow_in) annotation (Line(
      points={{102,0},{102,180},{128,180}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(Control.ChiOn, chi.on) annotation (Line(
      points={{102,0},{102,112},{158,112}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(Control.CHWSupSet, chi.TSet) annotation (Line(
      points={{102,0},{102,106},{158,106}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(val1.y, val4.y) annotation (Line(
      points={{272.8,90},{267,90},{267,109}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(val6.y, val5.y) annotation (Line(
      points={{132.8,90},{128,90},{128,98},{194,98},{194,146},{271,146},{271,143}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(Control.ValveChi, val6.y) annotation (Line(
      points={{102,0},{102,90},{132.8,90}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(Control.ValveWSE, val1.y) annotation (Line(
      points={{102,0},{102,48},{264,48},{264,90},{272.8,90}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(Control.ChiBypass, ChiBypass.y) annotation (Line(
      points={{102,0},{102,82},{171,82},{171,79.2}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(Control.WSEBypass, WSEBypass.y) annotation (Line(
      points={{102,0},{102,48},{222,48},{222,86},{245,86},{245,79.2}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(Control.ITLoadAir, roo.u) annotation (Line(
      points={{102,0},{102,-42},{170,-42}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(Control.Wetbulb, cooTow.TAir) annotation (Line(
      points={{102,0},{102,254},{230,254},{230,243},{219,243}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(TCHWEntChi.T, Temperature.TChiEnter) annotation (Line(
      points={{207,78.6},{207,82},{374,82},{374,0},{400,0}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(hex.port_a1, val3.port_b) annotation (Line(points={{216,264},{216,265},
          {238,265}}, color={0,127,255}));
  connect(val3.port_a, TCWret.port_a) annotation (Line(points={{248,265},{280,265},
          {280,172}}, color={0,127,255}));
  connect(hex.port_b1, cooTow.port_b) annotation (Line(points={{196,264},{140,264},
          {140,239},{197,239}}, color={0,127,255}));
  connect(val3.y, Control.ValveDCT) annotation (Line(
      points={{243,259},{242,259},{242,254},{102,254},{102,0}},
      color={217,67,180},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(hex.port_b2, bou1.ports[1]) annotation (Line(points={{216,276},{240,
          276},{240,290},{246,290}}, color={0,127,255}));
  connect(bou.T_in, Control.Drybulb) annotation (Line(
      points={{134,298},{102,298},{102,0}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(DCTFan.port_a, bou.ports[1]) annotation (Line(points={{164,293},{164,
          294},{156,294}}, color={0,127,255}));
  connect(DCTFan.port_b, hex.port_a2) annotation (Line(points={{184,293},{190,
          293},{190,276},{196,276}}, color={0,127,255}));
  connect(gain.y, DCTFan.m_flow_in)
    annotation (Line(points={{157,326},{174,326},{174,305}}, color={0,0,127}));
  connect(Control.DCTFan, gain.u) annotation (Line(
      points={{102,0},{102,326},{134,326}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(roo.TRooAir, Temperature.TAirRet) annotation (Line(
      points={{191,-42},{374,-42},{374,0},{400,0}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(TCDUSup.port_b, d2C.port_a) annotation (Line(points={{222,-3.5},{222,
          -10},{232,-10}}, color={0,127,255}));
  connect(d2C.u, Control.ITLoadCDU) annotation (Line(
      points={{231.6,-16},{222,-16},{222,-60},{102,-60},{102,0}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(TCDUSup.T, Temperature.TCDUSup) annotation (Line(
      points={{226.95,0.5},{226,0.5},{226,0},{400,0}},
      color={0,0,127},
      pattern=LinePattern.Dot));
  connect(expVesCDU.port_a, d2C.port_b) annotation (Line(points={{308,-8},{282,
          -8},{282,-10},{248,-10}}, color={0,127,255}));
  connect(EIT.u, PIT.y)
    annotation (Line(points={{308,-100},{287,-100}}, color={0,0,127}));
  connect(gain1.y, fan.m_flow_in) annotation (Line(points={{128.2,-12},{128,
          -11.5},{132.8,-11.5}}, color={0,0,127}));
  connect(gain1.u, Control.AHUFan) annotation (Line(
      points={{123.6,-12},{102,-12},{102,0}},
      color={217,67,180},
      pattern=LinePattern.Dot,
      thickness=0.5));
  connect(cooCoi.port_b1, TCHWret.port_a) annotation (Line(points={{202,22.8},{206,
          22.8},{206,44},{280,44},{280,40}}, color={0,127,255}));
  connect(cooCoi.port_a1, AHUValve.port_b) annotation (Line(points={{186,22.8},{
          186,22},{184,22}}, color={0,127,255}));
  connect(AHUValve.port_a, TCHWsup.port_b)
    annotation (Line(points={{174,22},{170,22},{170,23}}, color={0,127,255}));
  connect(CDUValve.port_a, TCHWsup.port_b)
    annotation (Line(points={{174,44},{170,44},{170,23}}, color={0,127,255}));
  connect(Control.AHUActivate, AHUValve.y) annotation (Line(
      points={{102,0},{102,34},{179,34},{179,29.2}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(Control.CDUActivate, CDUValve.y) annotation (Line(
      points={{102,0},{102,54},{179,54},{179,51.2}},
      color={217,67,180},
      thickness=0.5,
      pattern=LinePattern.Dot));
  connect(pumCHW.port_b, TCHWsup.port_a)
    annotation (Line(points={{156,23},{158,23}}, color={0,127,255}));
  connect(pumCHW.port_a, ChiBypass.port_b) annotation (Line(points={{146,23},{
          140,23},{140,72},{166,72}}, color={0,127,255}));
  connect(Control.PumpCHW, pumCHW.dp_in) annotation (Line(
      points={{102,0},{102,32},{151,32},{151,29}},
      color={255,204,51},
      thickness=0.5));
  connect(CDU.port_b1, TCHWret.port_a) annotation (Line(points={{244,22.8},{280,
          22.8},{280,40}}, color={0,127,255}));
  connect(CDU.port_b2, TCDUSup.port_a) annotation (Line(points={{228,13.2},{228,
          14},{222,14},{222,4.5}}, color={0,127,255}));
  connect(CDU.port_a2, d2C.port_b) annotation (Line(points={{244,13.2},{254,13.2},
          {254,-10},{248,-10}}, color={0,127,255}));
  connect(CDUValve.port_b, CDU.port_a1) annotation (Line(points={{184,44},{204,44},
          {204,32},{222,32},{222,22.8},{228,22.8}}, color={0,127,255}));
  connect(water.Valve, Control.ValveWCT)
    annotation (Line(points={{158,-102},{102,-102},{102,0}}, color={0,0,127}));
  connect(water.TWb, Control.Wetbulb)
    annotation (Line(points={{158,-106},{102,-106},{102,0}}, color={0,0,127}));
  connect(water.TCWSup, Temperature.TCWSup) annotation (Line(points={{158,-114},
          {144,-114},{144,-126},{374,-126},{374,0},{400,0}}, color={0,0,127}));
  connect(water.TCWRet, Temperature.TCWRet) annotation (Line(points={{158,-118},
          {148,-118},{148,-124},{374,-124},{374,0},{400,0}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{100,-180},{400,280}})),
Documentation(info="<HTML>
<p>
This model is the chilled water plant with discrete time control and
trim and respond logic for a data center. The model is described at
<a href=\"modelica://Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 6, 2021, by Michael Wetter:<br/>
Changed initialization from steady-state initial to fixed initial.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2798\">issue 2798</a>.
</li>
<li>
November 18, 2021, by Michael Wetter:<br/>
Set <code>dp_nominal</code> for pumps and fan to a realistic value.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2761\">#2761</a>.
</li>
<li>
September 21, 2017, by Michael Wetter:<br/>
Set <code>from_dp = true</code> in <code>val6</code> and in <code>valByp</code>
which is needed for Dymola 2018FD01 beta 2 for
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterDiscreteTimeControl</a>
to converge.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">IBPSA, #404</a>.
</li>
<li>
January 13, 2015 by Michael Wetter:<br/>
Moved model to <code>BaseClasses</code> because the continuous and discrete time
implementation of the trim and respond logic do not extend from a common class,
and hence the <code>constrainedby</code> operator is not applicable.
Moving the model here allows to implement both controllers without using a
<code>replaceable</code> class.
</li>
<li>
January 12, 2015 by Michael Wetter:<br/>
Made media instances replaceable, and used the same instance for both
water loops.
This was done to simplify the numerical benchmarks.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
March 25, 2014, by Michael Wetter:<br/>
Updated model with new expansion vessel.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
Removed the filtered speed calculation for the valves to reduce computing time by 25%.
</li>
<li>
October 16, 2012, by Wangda Zuo:<br/>
Reimplemented the controls.
</li>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Added comments and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{100,-180},{400,280}})),
    experiment(StopTime=3600, __Dymola_Algorithm="Dassl"));
end DataCenter;
