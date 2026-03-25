within DataCentersConfigurations.Architecture;
model DataCenterPaperSchematic
  "Primary only chiller plant system with water-side economizer"
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

  ChillerPlant.BaseClasses.SimplifiedRoom roo(
    redeclare package Medium = MediumA,
    rooLen=50,
    rooWid=30,
    rooHei=3,
    m_flow_nominal=mAir_flow_nominal,
    QRoo_flow=500000,
    nPorts=2) "Room model" annotation (Placement(transformation(extent={{-8,8},{
            8,-8}},    origin={172,-42})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{-6,7},{6,-7}},
        rotation=90,
        origin={305,28})));
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
        extent={{11,-10},{-11,10}},
        origin={211,200})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness wse(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    eps=0.8,
    dp2_nominal=0,
    dp1_nominal=0) "Water side economizer (Heat exchanger)"
    annotation (Placement(transformation(extent={{240,96},{260,117}})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_PEH_1104kW_8_00COP_Vanes(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{160,97},{180,117}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower" annotation (
      Placement(transformation(
        extent={{7,6},{-7,-6}},
        origin={140,139},
        rotation=90)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWret(redeclare package Medium =
        MediumW, m_flow_nominal=mCW_flow_nominal)
    "Temperature of condenser water leaving the cooling tower" annotation (
      Placement(transformation(
        extent={{6.5,-6},{-6.5,6}},
        origin={280,139.5},
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
        origin={210,174})));
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
    annotation (Placement(transformation(extent={{162,-6},{180,12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWsup(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal)
    "Temperature of chilled water leaving the cooling coil" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={140,38})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCW(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel" annotation (Placement(
        transformation(
        extent={{-6,7},{6,-7}},
        rotation=90,
        origin={305,112})));
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
     annotation (Placement(transformation(extent={{222,232},{200,212}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = MediumA,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{140,230},{160,250}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = MediumA,
    use_T_in=false,
    nPorts=1)
    annotation (Placement(transformation(extent={{280,230},{260,250}})));
  Components.D2C d2C(v=20)
    annotation (Placement(transformation(extent={{242,-48},{258,-32}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal/5)
    "Supply CDU temperature to data center" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        origin={230,-40},
        rotation=0)));
  Buildings.Fluid.Storage.ExpansionVessel expVesCDU(redeclare package Medium =
        MediumW, V_start=1) "Expansion vessel" annotation (Placement(
        transformation(
        extent={{-6,7},{6,-7}},
        rotation=90,
        origin={305,-2})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage AHUValve(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=1,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(extent={{-4,-4},{4,4}}, origin={160,18},
        rotation=-90)));
  Buildings.Fluid.Movers.FlowControlled_dp pumCHW(
    redeclare package Medium = Buildings.Media.Water "Water",
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mCHW_flow_nominal,
    dp_nominal=130000)
    annotation (Placement(transformation(extent={{-8,-8},{8,8}},
        rotation=-90,
        origin={140,60})));
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
    annotation (Placement(transformation(extent={{240,-6},{258,12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup1(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal/5)
    "Supply CDU temperature to data center" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        origin={154,-32},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup2(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal/5)
    "Supply CDU temperature to data center" annotation (Placement(
        transformation(
        extent={{6,-6},{-6,6}},
        origin={210,80},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup3(redeclare package Medium
      = MediumW, m_flow_nominal=mCHW_flow_nominal/5)
    "Supply CDU temperature to data center" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        origin={280,60},
        rotation=90)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage CDUValve(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=1,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        origin={160,40},
        rotation=-90)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage CDUValve5(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=1,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        origin={170,80},
        rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage CDUValve1(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=1,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        origin={250,80},
        rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage CDUValve2(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=1,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        origin={140,90},
        rotation=90)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage CDUValve3(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCHW_flow_nominal,
    dpValve_nominal=1,
    dpFixed_nominal=0,
    y_start=0,
    use_strokeTime=false,
    from_dp=true) "Bypass valve for chiller." annotation (Placement(
        transformation(
        extent={{4,-4},{-4,4}},
        origin={280,90},
        rotation=-90)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=0,
        origin={240,200})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=0,
        origin={240,216})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={270,128})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) "Control valve for condenser water loop of chiller"
    annotation (Placement(transformation(
        extent={{-4,-4},{4,4}},
        rotation=0,
        origin={270,112})));
  Buildings.Fluid.Movers.FlowControlled_m_flow DCTFan1(
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
        extent={{-8.5,-8},{8.5,8}},
        rotation=270,
        origin={140,-14.5})));
  Buildings.Fluid.Movers.FlowControlled_m_flow DCTFan2(
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
        extent={{-8.5,-8},{8.5,8}},
        rotation=270,
        origin={220,-14.5})));
  Buildings.Fluid.Movers.FlowControlled_m_flow DCTFan3(
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
        extent={{-8.5,-8},{8.5,8}},
        rotation=270,
        origin={140,159.5})));
  Buildings.Fluid.Movers.FlowControlled_m_flow DCTFan4(
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
        extent={{8.5,8},{-8.5,-8}},
        rotation=180,
        origin={180,227.5})));
equation

  connect(TCWSup.port_b, chi.port_a1) annotation (Line(points={{140,132},{140,
          113},{160,113}},
                      color={28,108,200},
      thickness=0.5));
  connect(TCWSup.port_b, wse.port_a1) annotation (Line(points={{140,132},{220,
          132},{220,112.8},{240,112.8}},  color={28,108,200},
      thickness=0.5));
  connect(val2.port_b, cooTow.port_b) annotation (Line(points={{206,174},{140,
          174},{140,200},{200,200}},
                                color={244,125,35},
      thickness=0.5));
  connect(val2.port_a, TCWret.port_a) annotation (Line(points={{214,174},{280,
          174},{280,146}},
                      color={238,46,47},
      thickness=0.5));
  connect(hex.port_b1, cooTow.port_b) annotation (Line(points={{200,216},{140,
          216},{140,200},{200,200}},
                                color={28,108,200},
      thickness=0.5));
  connect(hex.port_b2, bou1.ports[1]) annotation (Line(points={{222,228},{240,
          228},{240,240},{260,240}}, color={238,46,47},
      thickness=0.5));
  connect(TCDUSup.port_b, d2C.port_a) annotation (Line(points={{236,-40},{242,
          -40}},           color={28,108,200},
      thickness=0.5));
  connect(expVesCDU.port_a, d2C.port_b) annotation (Line(points={{298,-2},{280,
          -2},{280,-40},{258,-40}}, color={238,46,47},
      thickness=0.5));
  connect(CDU.port_a2, d2C.port_b) annotation (Line(points={{258,-2.4},{280,
          -2.4},{280,-40},{258,-40}},
                                color={238,46,47},
      thickness=0.5));
  connect(TCDUSup1.port_b, roo.airPorts[1]) annotation (Line(points={{160,-32},
          {171.55,-32},{171.55,-35.04}}, color={28,108,200},
      thickness=0.5));
  connect(cooCoi.port_a2, roo.airPorts[2]) annotation (Line(points={{180,-2.4},
          {200,-2.4},{200,-32},{173.17,-32},{173.17,-35.04}},
                                                            color={238,46,47},
      thickness=0.5));
  connect(chi.port_a2, TCDUSup2.port_b) annotation (Line(points={{180,101},{200,
          101},{200,80},{204,80}}, color={244,125,35},
      thickness=0.5));
  connect(TCDUSup2.port_a, wse.port_b2) annotation (Line(points={{216,80},{220,
          80},{220,100.2},{240,100.2}},
                                    color={244,125,35},
      thickness=0.5));
  connect(TCDUSup3.port_a, cooCoi.port_b1) annotation (Line(points={{280,54},{
          280,28},{200,28},{200,8.4},{180,8.4}},   color={238,46,47},
      thickness=0.5));
  connect(AHUValve.port_b, cooCoi.port_a1) annotation (Line(
      points={{160,14},{160,8.4},{162,8.4}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCHW.port_b, TCHWsup.port_a) annotation (Line(
      points={{140,52},{140,44}},
      color={28,108,200},
      thickness=0.5));
  connect(TCHWsup.port_b, AHUValve.port_a) annotation (Line(
      points={{140,32},{140,28},{160,28},{160,22}},
      color={28,108,200},
      thickness=0.5));
  connect(CDUValve.port_a, AHUValve.port_a) annotation (Line(
      points={{160,36},{160,22}},
      color={28,108,200},
      thickness=0.5));
  connect(CDUValve.port_b, CDU.port_a1) annotation (Line(
      points={{160,44},{160,48},{220,48},{220,8.4},{240,8.4}},
      color={28,108,200},
      thickness=0.5));
  connect(CDU.port_b1, cooCoi.port_b1) annotation (Line(
      points={{258,8.4},{280,8.4},{280,28},{200,28},{200,8.4},{180,8.4}},
      color={238,46,47},
      thickness=0.5));
  connect(expVesCHW.port_a, cooCoi.port_b1) annotation (Line(
      points={{298,28},{200,28},{200,8.4},{180,8.4}},
      color={238,46,47},
      thickness=0.5));
  connect(chi.port_b2, CDUValve2.port_a) annotation (Line(
      points={{160,101},{140,101},{140,94}},
      color={28,108,200},
      thickness=0.5));
  connect(CDUValve2.port_b, pumCHW.port_a) annotation (Line(
      points={{140,86},{140,68}},
      color={28,108,200},
      thickness=0.5));
  connect(CDUValve5.port_b, pumCHW.port_a) annotation (Line(
      points={{166,80},{140,80},{140,68}},
      color={28,108,200},
      thickness=0.5));
  connect(CDUValve1.port_b, wse.port_b2) annotation (Line(
      points={{246,80},{220,80},{220,100.2},{240,100.2}},
      color={244,125,35},
      thickness=0.5));
  connect(CDUValve1.port_a, TCDUSup3.port_b) annotation (Line(
      points={{254,80},{280,80},{280,66}},
      color={238,46,47},
      thickness=0.5));
  connect(CDUValve3.port_a, TCDUSup3.port_b) annotation (Line(
      points={{280,86},{280,66}},
      color={238,46,47},
      thickness=0.5));
  connect(CDUValve3.port_b, wse.port_a2) annotation (Line(
      points={{280,94},{280,100.2},{260,100.2}},
      color={238,46,47},
      thickness=0.5));
  connect(CDUValve5.port_a, TCDUSup2.port_b) annotation (Line(
      points={{174,80},{204,80}},
      color={244,125,35},
      thickness=0.5));
  connect(expVesCW.port_a, TCWret.port_b) annotation (Line(
      points={{298,112},{280,112},{280,133}},
      color={238,46,47},
      thickness=0.5));
  connect(cooTow.port_a, val1.port_b) annotation (Line(
      points={{222,200},{236,200}},
      color={238,46,47},
      thickness=0.5));
  connect(val1.port_a, TCWret.port_a) annotation (Line(
      points={{244,200},{280,200},{280,146}},
      color={238,46,47},
      thickness=0.5));
  connect(val3.port_b, hex.port_a1) annotation (Line(
      points={{236,216},{222,216}},
      color={238,46,47},
      thickness=0.5));
  connect(val3.port_a, TCWret.port_a) annotation (Line(
      points={{244,216},{280,216},{280,146}},
      color={238,46,47},
      thickness=0.5));
  connect(chi.port_b1, val4.port_a) annotation (Line(
      points={{180,113},{200,113},{200,128},{266,128}},
      color={238,46,47},
      thickness=0.5));
  connect(val4.port_b, TCWret.port_b) annotation (Line(
      points={{274,128},{280,128},{280,133}},
      color={238,46,47},
      thickness=0.5));
  connect(wse.port_b1, val5.port_a) annotation (Line(
      points={{260,112.8},{260,112},{266,112}},
      color={238,46,47},
      thickness=0.5));
  connect(val5.port_b, TCWret.port_b) annotation (Line(
      points={{274,112},{280,112},{280,133}},
      color={238,46,47},
      thickness=0.5));
  connect(DCTFan1.port_a, cooCoi.port_b2) annotation (Line(
      points={{140,-6},{140,-2},{162,-2},{162,-2.4}},
      color={28,108,200},
      thickness=0.5));
  connect(DCTFan1.port_b, TCDUSup1.port_a) annotation (Line(
      points={{140,-23},{140,-32},{148,-32}},
      color={28,108,200},
      thickness=0.5));
  connect(CDU.port_b2, DCTFan2.port_a) annotation (Line(
      points={{240,-2.4},{240,-2},{220,-2},{220,-6}},
      color={28,108,200},
      thickness=0.5));
  connect(DCTFan2.port_b, TCDUSup.port_a) annotation (Line(
      points={{220,-23},{220,-40},{224,-40}},
      color={28,108,200},
      thickness=0.5));
  connect(TCWSup.port_a, DCTFan3.port_b)
    annotation (Line(points={{140,146},{140,151}}, color={0,127,255}));
  connect(DCTFan3.port_a, cooTow.port_b) annotation (Line(
      points={{140,168},{140,200},{200,200}},
      color={28,108,200},
      thickness=0.5));
  connect(DCTFan4.port_b, hex.port_a2) annotation (Line(
      points={{188.5,227.5},{188,228},{200,228}},
      color={28,108,200},
      thickness=0.5));
  connect(bou.ports[1], DCTFan4.port_a) annotation (Line(
      points={{160,240},{164,240},{164,227.5},{171.5,227.5}},
      color={28,108,200},
      thickness=0.5));
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
end DataCenterPaperSchematic;
