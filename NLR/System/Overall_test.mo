within NLR.System;
model Overall_test
  import ModelicaServices;
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=18 "Nominal mass flow rate at fan";
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
    m2_flow_nominal=mAir_flow_nominal,
    UA_nominal=mAir_flow_nominal*1006*5,
    dpValve_nominal=6000,
    dp1_nominal=30000,
    dp2_nominal=600,
    perFan(pressure(dp=800*{1.2,1.12,1}, V_flow=mAir_flow_nominal/1.29*{0,0.5,1}),
        motorCooledByFluid=false),
    QHeaMax_flow=30000,
    mWatMax_flow=0.01,
    yValSwi=0.2)
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
  Equipment.WSE HX(
    redeclare package Medium1 = Buildings.Media.Water "Water",
    redeclare package Medium2 = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,16},{10,36}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUSup(redeclare replaceable
      package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",    m_flow_nominal=
        mCHW_flow_nominal) "Supply Fluid temperature" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,-64})));
  Equipment.D2C D2C
    annotation (Placement(transformation(extent={{40,-84},{60,-64}})));
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
        extent={{6,-6},{-6,6}},
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
      package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",    m_flow_nominal=
        mCHW_flow_nominal) "Return CDU temperature" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-64})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCDU(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction",
                 V_start=1) "Expansion vessel" annotation (Placement(
        transformation(
        extent={{-6,7},{6,-7}},
        rotation=90,
        origin={111,-40})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction",
                 V_start=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{-6,7},{6,-7}},
        rotation=90,
        origin={111,-28})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCW(redeclare package Medium =
        Buildings.Media.Water "Water",
                 V_start=1) "Expansion vessel" annotation (Placement(
        transformation(
        extent={{-6,7},{6,-7}},
        rotation=90,
        origin={111,32})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCHW(
    redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    m_flow_nominal=mCHW_flow_nominal,
    dp(start=214992),
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=130000) "Chilled water pump"   annotation (Placement(
        transformation(
        extent={{8,-8},{-8,8}},
        rotation=0,
        origin={-40,20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCDUEnt(redeclare replaceable
      package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",    m_flow_nominal=
        mCHW_flow_nominal) "Supply Fluid temperature" annotation (Placement(
        transformation(
        extent={{5,6},{-5,-6}},
        rotation=180,
        origin={11,-28})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-180,160},{-160,180}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3  weaData(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/DRYCOLD.mos"))
    annotation (Placement(transformation(extent={{-220,160},{-200,180}})));
  Buildings.Controls.Continuous.LimPID ahuValSig(
    Ti=40,
    reverseActing=false,
    yMin=0.1,
    k=0.01)          "Valve position signal for the AHU"
    annotation (Placement(transformation(extent={{-200,-14},{-180,6}})));
  Modelica.Blocks.Sources.Constant TAirSupSet(k=273.15 + 21.5)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-258,-14},{-238,6}})));
  Modelica.Blocks.Sources.Constant phiAirRetSet(k=0.5)
    "Return air relative humidity setpoint"
    annotation (Placement(transformation(extent={{-298,-24},{-278,-4}})));
  Buildings.Utilities.Psychrometrics.X_pTphi
                                   XAirSupSet(use_p_in=false)
    "Mass fraction setpoint of supply air "
    annotation (Placement(transformation(extent={{-258,-24},{-238,-44}})));
  Modelica.Blocks.Sources.Constant TAirRetSet(k=273.15 + 30.22)
    "Return air temperature setpoint"
    annotation (Placement(transformation(extent={{-298,-100},{-278,-80}})));
  Buildings.Controls.Continuous.LimPID ahuFanSpeCon(
    k=0.1,
    reverseActing=false,
    yMin=0.2,
    Ti=240) "Fan speed controller "
    annotation (Placement(transformation(extent={{-238,-100},{-218,-80}})));
  Modelica.Blocks.Sources.RealExpression TCWWet(y=min(23.89 + 273.15, max(273.15
         + 12.78, weaBus.TWetBul + 3)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.Continuous.LimPID
                             conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Modelica.Blocks.Sources.Constant ReturnSet(k=273.15 + 3)
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Modelica.Blocks.Sources.Constant no(k=1)
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-150,100},{-130,80}})));
  Modelica.Blocks.Sources.Constant MassFLow(k=mCW_flow_nominal)
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Modelica.Blocks.Sources.Constant Qflow(k=0.8) "MW"
    annotation (Placement(transformation(extent={{-260,-160},{-240,-140}})));
  Modelica.Blocks.Math.Gain QflowAir(k=0.3)
    annotation (Placement(transformation(extent={{-180,-142},{-160,-122}})));
  Modelica.Blocks.Math.Gain QflowLiq(k=0.7)
    annotation (Placement(transformation(extent={{-180,-180},{-160,-160}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear Mix(
    redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    m_flow_nominal=mCW_flow_nominal,
    dpValve_nominal=20902,
    dpFixed_nominal=89580,
    y_start=1,
    use_strokeTime=false) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-40,-10})));
  Buildings.Controls.Continuous.LimPID mixValSig(
    Ti=40,
    reverseActing=false,
    yMin=0.1,
    k=0.01) "Valve position signal for the Mixing valve"
    annotation (Placement(transformation(extent={{-134,20},{-114,40}})));
  Modelica.Blocks.Sources.Constant TLiqSupSet(k=273.15 + 23.35)
    "Supply liquid temperature setpoint"
    annotation (Placement(transformation(extent={{-172,20},{-152,40}})));
  Modelica.Blocks.Sources.Constant TLiqRetSet(k=273.15 + 35.5)
    "Return liq temperature setpoint"
    annotation (Placement(transformation(extent={{-398,52},{-378,72}})));
  Buildings.Controls.Continuous.LimPID CHWPumMasCon(
    k=0.1,
    reverseActing=false,
    yMin=0.1,
    Ti=240) annotation (Placement(transformation(extent={{-358,52},{-338,72}})));
  Buildings.Controls.Continuous.LimPID bypassCon(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for freezing bypass"
    annotation (Placement(transformation(extent={{-180,120},{-160,140}})));
  Modelica.Blocks.Math.Gain CHWmassflow(k=24.23)
    annotation (Placement(transformation(extent={{-310,52},{-290,72}})));
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
  connect(TCHWSup.port_b, AHU.port_a1) annotation (Line(
      points={{-80,-10},{-80,-28},{-60,-28}},
      color={28,108,200},
      thickness=0.5));
  connect(HX.port_a2, TCHWRet.port_a) annotation (Line(
      points={{10,20},{80,20},{80,10}},
      color={238,46,47},
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
  connect(TCWSup.port_b, HX.port_a1) annotation (Line(
      points={{-80,40},{-80,32},{-10,32}},
      color={28,108,200},
      thickness=0.5));
  connect(HX.port_b1, TCWRet.port_b) annotation (Line(
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
  connect(pumCHW.port_a, HX.port_b2) annotation (Line(
      points={{-32,20},{-10,20}},
      color={28,108,200},
      thickness=0.5));
  connect(pumCHW.port_b, TCHWSup.port_a) annotation (Line(
      points={{-48,20},{-80,20},{-80,10}},
      color={28,108,200},
      thickness=0.5));
  connect(TCDUEnt.port_b, CDU.port_a1) annotation (Line(
      points={{16,-28},{40,-28}},
      color={244,125,35},
      thickness=0.5));
  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{-200,170},{-170,170}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TWetBul, WCT.TAir) annotation (Line(
      points={{-169.95,170.05},{-169.95,170},{20,170},{20,90},{12,90}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TAirRetSet.y, ahuFanSpeCon.u_s)
    annotation (Line(points={{-277,-90},{-240,-90}}, color={0,0,127}));
  connect(ahuFanSpeCon.y, AHU.uFan) annotation (Line(
      points={{-217,-90},{-98,-90},{-98,-38},{-61,-38}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TAirSupSet.y, ahuValSig.u_s)
    annotation (Line(points={{-237,-4},{-202,-4}}, color={0,0,127}));
  connect(TAirSup.T, ahuValSig.u_m) annotation (Line(
      points={{-91,-64},{-190,-64},{-190,-16}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ahuValSig.y, AHU.uVal) annotation (Line(
      points={{-179,-4},{-96,-4},{-96,-30},{-61,-30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TAirRetSet.y, XAirSupSet.T) annotation (Line(points={{-277,-90},{-270,
          -90},{-270,-34},{-260,-34}}, color={0,0,127}));
  connect(phiAirRetSet.y, XAirSupSet.phi) annotation (Line(points={{-277,-14},{-268,
          -14},{-268,-28},{-260,-28}}, color={0,0,127}));
  connect(TAirSupSet.y, AHU.TSet) annotation (Line(
      points={{-237,-4},{-210,-4},{-210,-36},{-68,-36},{-68,-35},{-61,-35}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(XAirSupSet.X[1], AHU.XSet_w) annotation (Line(
      points={{-237,-34},{-138,-34},{-138,-33},{-61,-33}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TAirRet.T, ahuFanSpeCon.u_m) annotation (Line(
      points={{-9,-64},{-4,-64},{-4,-112},{-228,-112},{-228,-102}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(no.y, feedback.u1)
    annotation (Line(points={{-179,90},{-148,90}}, color={0,0,127}));
  connect(TCWWet.y, conFan.u_s)
    annotation (Line(points={{-99,150},{-82,150}}, color={0,0,127}));
  connect(conFan.y, WCT.y) annotation (Line(
      points={{-59,150},{12,150},{12,94}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCWRet.T, conFan.u_m) annotation (Line(
      points={{91,50},{96,50},{96,104},{-70,104},{-70,138}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(MassFLow.y, pumCW.m_flow_in) annotation (Line(
      points={{-99,190},{-40,190},{-40,95.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(Qflow.y, QflowAir.u) annotation (Line(points={{-239,-150},{-190,-150},
          {-190,-132},{-182,-132}}, color={0,0,127}));
  connect(Qflow.y, QflowLiq.u) annotation (Line(points={{-239,-150},{-192,-150},
          {-192,-170},{-182,-170}}, color={0,0,127}));
  connect(QflowAir.y, simplifiedRoom.u) annotation (Line(
      points={{-159,-132},{-152,-132},{-152,-74},{-60,-74}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(QflowLiq.y, D2C.u) annotation (Line(
      points={{-159,-170},{39.75,-170},{39.75,-73.9375}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCHWSup.port_b, Mix.port_a) annotation (Line(
      points={{-80,-10},{-46,-10}},
      color={28,108,200},
      thickness=0.5));
  connect(Mix.port_b, TCDUEnt.port_a) annotation (Line(
      points={{-34,-10},{-6,-10},{-6,-28},{6,-28}},
      color={28,108,200},
      thickness=0.5));
  connect(AHU.port_b1, TCDUEnt.port_a) annotation (Line(
      points={{-40,-28},{6,-28}},
      color={238,46,47},
      thickness=0.5));
  connect(TLiqSupSet.y, mixValSig.u_s)
    annotation (Line(points={{-151,30},{-136,30}}, color={0,0,127}));
  connect(TCDUEnt.T, mixValSig.u_m) annotation (Line(
      points={{11,-21.4},{11,6},{-124,6},{-124,18}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(mixValSig.y, Mix.y) annotation (Line(
      points={{-113,30},{-68,30},{-68,4},{-40,4},{-40,-2.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TLiqRetSet.y, CHWPumMasCon.u_s)
    annotation (Line(points={{-377,62},{-360,62}}, color={0,0,127}));
  connect(TCHWRet.T, CHWPumMasCon.u_m) annotation (Line(
      points={{91,0},{140,0},{140,-192},{-348,-192},{-348,50}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ReturnSet.y, bypassCon.u_s)
    annotation (Line(points={{-199,130},{-182,130}}, color={0,0,127}));
  connect(TCWRet.T, bypassCon.u_m) annotation (Line(
      points={{91,50},{96,50},{96,104},{-170,104},{-170,118}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(bypassCon.y, feedback.u2) annotation (Line(points={{-159,130},{-140,130},
          {-140,98}}, color={0,0,127}));
  connect(bypassCon.y, MainValve.y) annotation (Line(
      points={{-159,130},{32,130},{32,93.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(feedback.y, Bypass.y) annotation (Line(points={{-131,90},{-100,90},{
          -100,68},{-4,68},{-4,67.2},{0,67.2}},
                                           color={0,0,127},
      pattern=LinePattern.Dash));
  connect(CHWPumMasCon.y, CHWmassflow.u)
    annotation (Line(points={{-337,62},{-312,62}}, color={0,0,127}));
  connect(CHWmassflow.y, pumCHW.m_flow_in) annotation (Line(
      points={{-289,62},{-40,62},{-40,29.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},
            {120,120}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    experiment(
      StopTime=31536000,
      Interval=600,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file(ensureSimulated=true) =
        "Resources/scripts/System/Overall_test/Simulate and Plot.mos"
        "Simulate and Plot"));
end Overall_test;
