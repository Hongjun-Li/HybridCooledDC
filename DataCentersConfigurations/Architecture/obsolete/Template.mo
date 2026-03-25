within DataCentersConfigurations.Architecture.obsolete;
model Template
  import Buildings;
  parameter Real tcwsupset  = 273.15 + 6 "Condensor Water Supply Setpoint Temperature";
  parameter Real tchwsupset = 273.15 + 12 "Chilled Water Supply Setpoint Temperature";
  parameter Real tairsupset = 273.15 + 18 "Air Supply Setpoint Temperature";
  parameter Real tairretset = 273.15 + 25 "Air Return Setpoint Temperature";
  parameter Real tcdusupset = 273.15 + 32 "CDU Supply Setpoint Temperature";
  parameter Real tcduretset = 273.15 + 55 "CDU Return Setpoint Temperature";
 package MediumW = Buildings.Media.Water "Medium model";
   parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=10.35
    "Nominal mass flow rate at evaporator";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=19.24
    "Nominal mass flow rate at condenser";
  parameter Modelica.Units.SI.Pressure dp1_nominal=60000
    "Nominal pressure difference on medium 1 side";
  parameter Modelica.Units.SI.Pressure dp2_nominal=60000
    "Nominal pressure difference on medium 2 side";
    // Chiller parameters
  parameter Modelica.Units.SI.MassFlowRate m1_flow_chi_nominal=19.24
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_chi_nominal=10.35
    "Nominal mass flow rate at evaporator water in the chillers";
  parameter Modelica.Units.SI.PressureDifference dp1_chi_nominal=30*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dp2_chi_nominal=30*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.Power QEva_nominal=m2_flow_chi_nominal*4200*(8.89
       - 26.67) "Nominal cooling capaciaty(Negative means cooling)";
 // WSE parameters
  parameter Modelica.Units.SI.MassFlowRate m1_flow_wse_nominal=10.35
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_wse_nominal=10.35
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.PressureDifference dp1_wse_nominal=33.1*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dp2_wse_nominal=34.5*1000
    "Nominal pressure";
  parameter Integer numChi = 1;
// AHU
  parameter Modelica.Units.SI.ThermalConductance UA_nominal=numChi*QEva_nominal
      /Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
      6.67,
      11.56,
      12,
      25);
  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPum(each pressure=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
        V_flow=m2_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
        dp=dp2_chi_nominal*{1.2,1.1,1.0,0.6})) "Pump performance data"
    annotation (Placement(transformation(extent={{52,80},{72,100}})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc WCT(redeclare package
      Medium = Buildings.Media.Water "Water", allowFlowReversal=false,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal=6000,
    TAirInWB_nominal=283.15,
    PFan_nominal=18000,
    TApp_nominal=6)
    annotation (Placement(transformation(extent={{30,22},{10,42}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{124,86},{146,108}}),
        iconTransformation(extent={{122,86},{142,106}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    weaDat(filNam="D:/Github/DataCenterArchitecture/weather/1A.mos")
           annotation (Placement(transformation(extent={{180,86},{160,106}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU
    DCT(
    redeclare package Medium1 = Buildings.Media.Air "Moist air",
    redeclare package Medium2 = Buildings.Media.Water "Water",
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m1_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    use_Q_flow_nominal=false,
    eps_nominal=0.8)
    annotation (Placement(transformation(extent={{10,48},{30,68}})));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    V1(redeclare package Medium = Buildings.Media.Water "Water",
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=1)
    annotation (Placement(transformation(extent={{66,26},{54,38}})));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    V2(redeclare package Medium = Buildings.Media.Water "Water",
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=1)
    annotation (Placement(transformation(extent={{26,2},{14,14}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.IntegratedPrimaryLoadSide
    integratedPrimaryLoadSide(
    redeclare package Medium1 = Buildings.Media.Water "Water",
    redeclare package Medium2 = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    m1_flow_chi_nominal=m1_flow_chi_nominal,
    m2_flow_chi_nominal=m2_flow_chi_nominal,
    m1_flow_wse_nominal=m1_flow_wse_nominal,
    m2_flow_wse_nominal=m2_flow_wse_nominal,
    dp1_chi_nominal=dp1_chi_nominal,
    dp1_wse_nominal=dp1_wse_nominal,
    dp2_chi_nominal=dp2_chi_nominal,
    dp2_wse_nominal=dp2_wse_nominal,
    numChi=numChi,
    redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1023kW_5_81COP_Vanes
      perChi,
    perPum=perPum)
              annotation (Placement(transformation(extent={{10,-64},{30,-44}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow mov(
      redeclare package Medium = Buildings.Media.Water "Water",
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8 per,
    m_flow_nominal=m1_flow_nominal)                             annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-62,-30})));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    V3(redeclare package Medium = Buildings.Media.Water "Water",
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=1)
    annotation (Placement(transformation(extent={{66,46},{54,58}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.CoolingCoilHumidifyingHeating
    AHU(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction", redeclare package
      Medium2 = Buildings.Media.Air "Moist air",
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=155,
    UA_nominal=UA_nominal,
    dpValve_nominal=6000,
    dp1_nominal=30000,
    dp2_nominal=600,
    perFan(pressure(V_flow=155/1.29*{0,0.5,1}, dp=800*{1.2,1.12,1})),
    QHeaMax_flow=30000,
    mWatMax_flow=0.01,
    yValSwi=0.1,
    yValDeaBan=0.05)
    annotation (Placement(transformation(extent={{-38,-134},{-18,-114}})));
  DataCentersConfigurations.Components.CDU CDU(
    redeclare package Medium1 = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    redeclare package Medium2 = Buildings.Media.Water "Water",
    allowFlowReversal1=false,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m1_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    eta=0.8)
    annotation (Placement(transformation(extent={{32,-132},{52,-116}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU
    DCT1(
    redeclare package Medium1 = Buildings.Media.Air "Moist air",
    redeclare package Medium2 = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m1_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=6000,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    use_Q_flow_nominal=false,
    eps_nominal=0.8)          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={106,-100})));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    V8(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction",
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=1)
    annotation (Placement(transformation(extent={{36,-104},{48,-92}})));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    V4(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction",
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=1)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={84,-104})));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent
    V7(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction",
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=1)
    annotation (Placement(transformation(extent={{-38,-104},{-26,-92}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Buildings.Media.Air "Moist air",
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-42,70},{-22,90}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Buildings.Media.Air "Moist air",
    use_T_in=false,
    nPorts=1) annotation (Placement(transformation(extent={{82,70},{62,90}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium = Buildings.Media.Air "Moist air",
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={130,-60})));
  Buildings.Fluid.Sources.Boundary_pT bou3(
    redeclare package Medium = Buildings.Media.Air "Moist air",
    use_T_in=false,
    nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={130,-140})));
  Components.D2C d2C
    annotation (Placement(transformation(extent={{32,-180},{52,-160}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort Tcdusup(
      redeclare package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        m1_flow_nominal)                                        annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={20,-144})));
  Buildings.Fluid.Sensors.TemperatureTwoPort Tcduret(
      redeclare package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        m1_flow_nominal)                                        annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={62,-152})));

  Buildings.Fluid.Sensors.TemperatureTwoPort Tairsup(
      redeclare package Medium = Buildings.Media.Air "Moist air",
      m_flow_nominal=155)                                         annotation (
      Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=90,
        origin={-52,-152})));
  Buildings.Fluid.Sensors.TemperatureTwoPort Tairret(
      redeclare package Medium = Buildings.Media.Air "Moist air",
      m_flow_nominal=155)                                         annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-4,-144})));
  Buildings.Fluid.Sensors.TemperatureTwoPort Tchwsup(redeclare package Medium
      = Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction", m_flow_nominal=
        m1_flow_nominal)                                      annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={-60,-82})));
  Buildings.Fluid.Sensors.TemperatureTwoPort Tchwret(
      redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction", m_flow_nominal=
        m1_flow_nominal)                                      annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={84,-82})));
  Buildings.Fluid.Sensors.TemperatureTwoPort Tcwret(
      redeclare package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        m1_flow_nominal)                                        annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={100,-6})));
  Buildings.Fluid.Sensors.TemperatureTwoPort Tcwsup(
      redeclare package Medium = Buildings.Media.Water "Water", m_flow_nominal=
        m1_flow_nominal)                                        annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={-60,-10})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare replaceable
      package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction")
    "Differential pressure"
    annotation (Placement(transformation(extent={{10,-64},{30,-84}})));
  Modelica.Blocks.Sources.Constant tcdusup(k=tcdusupset)
    annotation (Placement(transformation(extent={{20,-126},{24,-122}})));
  Modelica.Blocks.Interfaces.RealInput CTFan annotation (Placement(
        transformation(extent={{-108,72},{-94,86}}), iconTransformation(extent={
            {-108,72},{-94,86}})));
  Modelica.Blocks.Interfaces.RealInput CTBypass annotation (Placement(
        transformation(extent={{-108,56},{-94,70}}), iconTransformation(extent={
            {-108,72},{-94,86}})));
  Modelica.Blocks.Interfaces.RealInput WCTv annotation (Placement(
        transformation(extent={{-108,44},{-94,58}}), iconTransformation(extent={
            {-108,72},{-94,86}})));
  Modelica.Blocks.Interfaces.RealInput DCTv annotation (Placement(
        transformation(extent={{-108,32},{-94,46}}), iconTransformation(extent={
            {-108,72},{-94,86}})));
  Modelica.Blocks.Interfaces.RealInput AHUval annotation (Placement(
        transformation(extent={{-108,-114},{-94,-100}}), iconTransformation(
          extent={{-108,-108},{-94,-94}})));
  Modelica.Blocks.Interfaces.RealInput AHUxset annotation (Placement(
        transformation(extent={{-108,-126},{-94,-112}}), iconTransformation(
          extent={{-108,-108},{-94,-94}})));
  Modelica.Blocks.Interfaces.RealInput AHUtset annotation (Placement(
        transformation(extent={{-108,-136},{-94,-122}}), iconTransformation(
          extent={{-108,-108},{-94,-94}})));
  Modelica.Blocks.Interfaces.RealInput AHUFan annotation (Placement(
        transformation(extent={{-108,-146},{-94,-132}}), iconTransformation(
          extent={{-108,-108},{-94,-94}})));
  Modelica.Blocks.Interfaces.RealInput AHUbypass annotation (Placement(
        transformation(extent={{-108,-104},{-94,-90}}), iconTransformation(
          extent={{-108,-108},{-94,-94}})));
  Modelica.Blocks.Interfaces.RealInput v4 annotation (Placement(transformation(
          extent={{-108,-6},{-94,8}}), iconTransformation(extent={{-108,-6},{-94,
            8}})));
  Modelica.Blocks.Interfaces.RealInput ITAir annotation (Placement(
        transformation(extent={{-108,-168},{-94,-154}}), iconTransformation(
          extent={{-108,-154},{-94,-140}})));
  Modelica.Blocks.Interfaces.RealInput ITLiquid annotation (Placement(
        transformation(extent={{-108,-178},{-94,-164}}), iconTransformation(
          extent={{-108,-154},{-94,-140}})));
  Modelica.Blocks.Interfaces.RealInput CDUactivate annotation (Placement(
        transformation(extent={{-108,-158},{-94,-144}}), iconTransformation(
          extent={{-108,-154},{-94,-140}})));
  Modelica.Blocks.Math.Feedback feedback1
    annotation (Placement(transformation(extent={{8,-92},{20,-80}})));
  Modelica.Blocks.Sources.Constant const(k=1)
    annotation (Placement(transformation(extent={{0,-88},{4,-84}})));
  Modelica.Blocks.Interfaces.RealInput WSEbypass annotation (Placement(
        transformation(extent={{-108,-66},{-94,-52}}), iconTransformation(
          extent={{-108,-66},{-94,-52}})));
  Modelica.Blocks.Interfaces.RealInput Chibypass annotation (Placement(
        transformation(extent={{-108,-76},{-94,-62}}), iconTransformation(
          extent={{-108,-66},{-94,-52}})));
  Modelica.Blocks.Interfaces.RealInput CHWpump annotation (Placement(
        transformation(extent={{-108,-86},{-94,-72}}), iconTransformation(
          extent={{-108,-66},{-94,-52}})));
  Modelica.Blocks.Interfaces.RealInput Tset annotation (Placement(
        transformation(extent={{-108,-54},{-94,-40}}), iconTransformation(
          extent={{-108,-66},{-94,-52}})));
  Modelica.Blocks.Interfaces.BooleanInput ChiOn annotation (Placement(
        transformation(extent={{-108,-32},{-98,-22}}), iconTransformation(
          extent={{-108,-32},{-98,-22}})));
  Modelica.Blocks.Interfaces.BooleanInput WSEOn annotation (Placement(
        transformation(extent={{-108,-40},{-98,-30}}), iconTransformation(
          extent={{-108,-32},{-98,-22}})));
  Modelica.Blocks.Interfaces.RealOutput tcwsup annotation (Placement(
        transformation(extent={{138,44},{158,64}}), iconTransformation(extent={
            {138,44},{158,64}})));
  Modelica.Blocks.Interfaces.RealOutput tcwret annotation (Placement(
        transformation(extent={{138,22},{158,42}}), iconTransformation(extent={
            {138,20},{158,40}})));
  Modelica.Blocks.Interfaces.RealOutput tairsup annotation (Placement(
        transformation(extent={{138,6},{158,26}}), iconTransformation(extent={{
            138,-12},{158,8}})));
  Modelica.Blocks.Interfaces.RealOutput tairret annotation (Placement(
        transformation(extent={{138,-8},{158,12}}), iconTransformation(extent={
            {138,-40},{158,-20}})));
  Modelica.Blocks.Interfaces.RealOutput dp annotation (Placement(transformation(
          extent={{138,-22},{158,-2}}), iconTransformation(extent={{138,-68},{
            158,-48}})));
  Modelica.Blocks.Sources.Constant const1(k=m1_flow_nominal)
    annotation (Placement(transformation(extent={{-38,-32},{-42,-28}})));
  Components.SimplifiedRoom simplifiedRoom
    annotation (Placement(transformation(extent={{-36,-178},{-20,-162}})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi(redeclare replaceable package
      Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15,
          X_a=0.40) "Propylene glycol water, 40% mass fraction", nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={170,-109})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi1(redeclare replaceable package
      Medium = Buildings.Media.Water "Water", nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={182,9})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi2(redeclare replaceable package
      Medium = Buildings.Media.Water "Water", nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={186,-163})));
equation
  connect(weaBus, weaDat.weaBus) annotation (Line(
      points={{135,97},{156,97},{156,96},{160,96}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TWetBul, WCT.TAir) annotation (Line(
      points={{135.055,97.055},{135.055,36},{32,36}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(V1.port_b, WCT.port_a) annotation (Line(
      points={{54,32},{30,32}},
      color={0,127,255},
      thickness=0.5));
  connect(mov.port_b, integratedPrimaryLoadSide.port_a1) annotation (Line(
      points={{-62,-40},{-62,-48},{10,-48}},
      color={0,127,255},
      thickness=0.5));
  connect(V2.port_a, V1.port_a) annotation (Line(
      points={{26,8},{100,8},{100,32},{66,32}},
      color={0,127,255},
      thickness=0.5));
  connect(V2.port_b, WCT.port_b) annotation (Line(
      points={{14,8},{-60,8},{-60,32},{10,32}},
      color={0,127,255},
      thickness=0.5));
  connect(V3.port_a, V1.port_a) annotation (Line(
      points={{66,52},{100,52},{100,32},{66,32}},
      color={0,127,255},
      thickness=0.5));
  connect(V3.port_b, DCT.port_a2) annotation (Line(
      points={{54,52},{30,52}},
      color={0,127,255},
      thickness=0.5));
  connect(DCT.port_b2, WCT.port_b) annotation (Line(
      points={{10,52},{-60,52},{-60,32},{10,32}},
      color={0,127,255},
      thickness=0.5));
  connect(V4.port_a, CDU.port_b1) annotation (Line(
      points={{84,-110},{84,-118},{52,-118}},
      color={28,108,200},
      thickness=0.5));
  connect(V8.port_b, CDU.port_b1) annotation (Line(
      points={{48,-98},{64,-98},{64,-118},{52,-118}},
      color={28,108,200},
      thickness=0.5));
  connect(DCT.port_b1, bou1.ports[1]) annotation (Line(
      points={{30,64},{40,64},{40,80},{62,80}},
      color={0,140,72},
      thickness=0.5));
  connect(weaBus.TDryBul, bou.T_in) annotation (Line(
      points={{135.055,97.055},{120,97.055},{120,98},{-60,98},{-60,84},{-44,84}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, bou2.T_in) annotation (Line(
      points={{135.055,97.055},{136,97.055},{136,-48},{134,-48}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(bou2.ports[1], DCT1.port_a1) annotation (Line(
      points={{130,-70},{130,-86},{112,-86},{112,-90}},
      color={0,140,72},
      thickness=0.5));
  connect(DCT1.port_b1, bou3.ports[1]) annotation (Line(
      points={{112,-110},{112,-124},{130,-124},{130,-130}},
      color={0,140,72},
      thickness=0.5));
  connect(Tcdusup.port_b, d2C.port_a) annotation (Line(
      points={{20,-150},{20,-170},{32,-170}},
      color={244,125,35},
      thickness=0.5));
  connect(CDU.port_b2, Tcdusup.port_a) annotation (Line(
      points={{32,-130},{20,-130},{20,-138}},
      color={244,125,35},
      thickness=0.5));
  connect(d2C.port_b, Tcduret.port_a) annotation (Line(
      points={{52,-170},{62,-170},{62,-158}},
      color={244,125,35},
      thickness=0.5));
  connect(Tcduret.port_b, CDU.port_a2) annotation (Line(
      points={{62,-146},{62,-130},{52,-130}},
      color={244,125,35},
      thickness=0.5));
  connect(Tairsup.port_a, AHU.port_b2) annotation (Line(
      points={{-52,-146},{-52,-130},{-38,-130}},
      color={244,125,35},
      thickness=0.5));
  connect(Tairret.port_b, AHU.port_a2) annotation (Line(
      points={{-4,-138},{-4,-130},{-18,-130}},
      color={244,125,35},
      thickness=0.5));
  connect(Tchwsup.port_a, integratedPrimaryLoadSide.port_b2) annotation (Line(
      points={{-60,-76},{-60,-60},{10,-60}},
      color={0,127,255},
      thickness=0.5));
  connect(V4.port_b, Tchwret.port_a)
    annotation (Line(points={{84,-98},{84,-88}}, color={28,108,200},
      thickness=0.5));
  connect(DCT1.port_b2, Tchwret.port_a) annotation (Line(
      points={{100,-90},{84,-90},{84,-88}},
      color={28,108,200},
      thickness=0.5));
  connect(integratedPrimaryLoadSide.port_a2, Tchwret.port_b) annotation (Line(
      points={{30,-60},{84,-60},{84,-76}},
      color={0,127,255},
      thickness=0.5));
  connect(Tcwret.port_b, V1.port_a) annotation (Line(
      points={{100,0},{100,32},{66,32}},
      color={0,127,255},
      thickness=0.5));
  connect(Tcwsup.port_b, mov.port_a) annotation (Line(
      points={{-60,-16},{-60,-20},{-62,-20}},
      color={0,127,255},
      thickness=0.5));
  connect(Tcwsup.port_a, WCT.port_b) annotation (Line(
      points={{-60,-4},{-60,32},{10,32}},
      color={0,127,255},
      thickness=0.5));
  connect(senRelPre.port_a, integratedPrimaryLoadSide.port_b2) annotation (Line(
      points={{10,-74},{-60,-74},{-60,-60},{10,-60}},
      color={28,108,200},
      thickness=0.5));
  connect(senRelPre.port_b, Tchwret.port_b) annotation (Line(
      points={{30,-74},{84,-74},{84,-76}},
      color={28,108,200},
      thickness=0.5));
  connect(tcdusup.y, CDU.TSet) annotation (Line(points={{24.2,-124},{26,-124},{26,
          -120},{30,-120}},                      color={0,0,127}));
  connect(Tchwsup.port_b, AHU.port_a1) annotation (Line(points={{-60,-88},{-60,
          -118},{-38,-118}}, color={0,127,255}));
  connect(V7.port_a, AHU.port_a1) annotation (Line(points={{-38,-98},{-44,-98},
          {-44,-118},{-38,-118}}, color={0,127,255}));
  connect(AHU.port_b1, CDU.port_a1)
    annotation (Line(points={{-18,-118},{32,-118}}, color={0,127,255}));
  connect(V8.port_a, CDU.port_a1) annotation (Line(points={{36,-98},{20,-98},{
          20,-118},{32,-118}},
                            color={0,127,255}));
  connect(V7.port_b, CDU.port_a1) annotation (Line(points={{-26,-98},{-4,-98},{
          -4,-118},{32,-118}},   color={0,127,255}));
  connect(DCT1.port_a2, CDU.port_b1) annotation (Line(points={{100,-110},{100,-118},
          {52,-118}},       color={0,127,255}));
  connect(integratedPrimaryLoadSide.port_b1, Tcwret.port_a) annotation (Line(
      points={{30,-48},{100,-48},{100,-12}},
      color={0,127,255},
      thickness=0.5));
  connect(CTFan, WCT.y) annotation (Line(
      points={{-101,79},{-50,79},{-50,46},{40,46},{40,40},{32,40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(CTBypass, V2.y) annotation (Line(
      points={{-101,63},{-52,63},{-52,16},{20,16},{20,15.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(WCTv, V1.y) annotation (Line(
      points={{-101,51},{-56,51},{-56,44},{60,44},{60,39.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(AHUval, AHU.uVal) annotation (Line(
      points={{-101,-107},{-62,-107},{-62,-120},{-39,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(AHU.XSet_w, AHUxset) annotation (Line(
      points={{-39,-123},{-66,-123},{-66,-119},{-101,-119}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(AHUtset, AHU.TSet) annotation (Line(
      points={{-101,-129},{-62,-129},{-62,-125},{-39,-125}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(AHUFan, AHU.uFan) annotation (Line(
      points={{-101,-139},{-60,-139},{-60,-128},{-39,-128}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(AHUbypass, V7.y) annotation (Line(
      points={{-101,-97},{-64,-97},{-64,-90},{-32,-90},{-32,-90.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(v4, V4.y) annotation (Line(
      points={{-101,1},{-76,1},{-76,-104},{76.8,-104}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ITLiquid, d2C.u) annotation (Line(
      points={{-101,-171},{-54,-171},{-54,-177.5},{31.5,-177.5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(CDUactivate, CDU.activate) annotation (Line(
      points={{-101,-151},{-64,-151},{-64,-110},{14,-110},{14,-114.6},{30,-114.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(const.y,feedback1. u1)
    annotation (Line(points={{4.2,-86},{9.2,-86}},   color={0,0,127}));
  connect(CDUactivate, feedback1.u2) annotation (Line(
      points={{-101,-151},{-64,-151},{-64,-110},{14,-110},{14,-90.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(feedback1.y, V8.y) annotation (Line(
      points={{19.4,-86},{42,-86},{42,-90.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(integratedPrimaryLoadSide.yVal5, WSEbypass) annotation (Line(points={
          {8.4,-51},{8.4,-52},{-88,-52},{-88,-59},{-101,-59}}, color={0,0,127}));
  connect(Chibypass, integratedPrimaryLoadSide.yVal6) annotation (Line(points={
          {-101,-69},{-86,-69},{-86,-54},{-38,-54},{-38,-54.2},{8.4,-54.2}},
        color={0,0,127}));
  connect(CHWpump, integratedPrimaryLoadSide.yPum[1]) annotation (Line(points={
          {-101,-79},{-82,-79},{-82,-58},{-36,-58},{-36,-58.4},{8.4,-58.4}},
        color={0,0,127}));
  connect(Tset, integratedPrimaryLoadSide.TSet) annotation (Line(points={{-101,
          -47},{-62,-47},{-62,-43.2},{8.4,-43.2}}, color={0,0,127}));
  connect(ChiOn, integratedPrimaryLoadSide.on[1]) annotation (Line(points={{
          -103,-27},{-82,-27},{-82,-46},{0,-46},{0,-46.4},{8.4,-46.4}}, color={
          255,0,255}));
  connect(WSEOn, integratedPrimaryLoadSide.on[2]) annotation (Line(points={{
          -103,-35},{-82,-35},{-82,-46},{0,-46},{0,-46.4},{8.4,-46.4}}, color={
          255,0,255}));
  connect(senRelPre.p_rel, dp) annotation (Line(
      points={{20,-65},{20,-64},{114,-64},{114,-12},{148,-12}},
      color={238,46,47},
      pattern=LinePattern.Dash));
  connect(WCT.TLvg, tcwsup) annotation (Line(
      points={{9,26},{2,26},{2,20},{80,20},{80,54},{148,54}},
      color={238,46,47},
      pattern=LinePattern.Dash));
  connect(Tcwret.T, tcwret) annotation (Line(
      points={{93.4,-6},{90,-6},{90,32},{148,32}},
      color={238,46,47},
      pattern=LinePattern.Dash));
  connect(tairret, Tairret.T) annotation (Line(
      points={{148,2},{148,-184},{-14,-184},{-14,-144},{-10.6,-144}},
      color={238,46,47},
      pattern=LinePattern.Dash));
  connect(tairsup, Tairsup.T) annotation (Line(
      points={{148,16},{156,16},{156,-186},{-60,-186},{-60,-152},{-58.6,-152}},
      color={238,46,47},
      pattern=LinePattern.Dash));
  connect(const1.y, mov.m_flow_in)
    annotation (Line(points={{-42.2,-30},{-50,-30}}, color={0,0,127}));
  connect(Tairsup.port_b, simplifiedRoom.port_a) annotation (Line(
      points={{-52,-158},{-52,-170},{-36,-170}},
      color={244,125,35},
      thickness=0.5));
  connect(simplifiedRoom.port_b, Tairret.port_a) annotation (Line(
      points={{-20,-170},{-4,-170},{-4,-150}},
      color={244,125,35},
      thickness=0.5));
  connect(ITAir, simplifiedRoom.u) annotation (Line(
      points={{-101,-161},{-40,-161},{-40,-176},{-36.4,-176}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(expVesChi.ports[1], CDU.port_b1) annotation (Line(points={{160,-109},{
          146,-109},{146,-110},{132,-110},{132,-118},{52,-118}}, color={0,127,255}));
  connect(expVesChi1.ports[1], V1.port_a) annotation (Line(points={{172,9},{136,
          9},{136,8},{100,8},{100,32},{66,32}}, color={0,127,255}));
  connect(expVesChi2.ports[1], Tcduret.port_a) annotation (Line(points={{176,-163},
          {120,-163},{120,-170},{62,-170},{62,-158}}, color={0,127,255}));
  connect(DCTv, V3.y) annotation (Line(points={{-101,39},{-58,39},{-58,66},{60,66},
          {60,59.2}}, color={0,0,127}));
  connect(bou.ports[1], DCT.port_a1) annotation (Line(points={{-22,80},{-12,80},
          {-12,64},{10,64}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -180},{140,100}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-180},{140,100}})));
end Template;
