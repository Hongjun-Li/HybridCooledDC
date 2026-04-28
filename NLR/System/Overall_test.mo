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
        extent={{5,-6},{-5,6}},
        rotation=180,
        origin={11,-28})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-100,174},{-80,194}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3  weaData(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/DRYCOLD.mos"))
    annotation (Placement(transformation(extent={{-160,174},{-140,194}})));
  Modelica.Blocks.Sources.Constant MassFLow(k=mCW_flow_nominal)
    annotation (Placement(transformation(extent={{-160,80},{-140,100}})));
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
  Control.Overall_test.Anti_freeze anti_freeze
    annotation (Placement(transformation(extent={{-160,112},{-140,132}})));
  Control.Overall_test.ahuCon ahuCon
    annotation (Placement(transformation(extent={{-160,-42},{-140,-22}})));
  Control.Overall_test.Qflow qflow
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Control.Overall_test.MixCon mixCon
    annotation (Placement(transformation(extent={{-160,-6},{-140,14}})));
  Control.Overall_test.CWpumCon cWpumCon
    annotation (Placement(transformation(extent={{-160,42},{-140,62}})));
  Control.Overall_test.CTCon cTCon
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));
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
  connect(weaBus.TWetBul, WCT.TAir) annotation (Line(
      points={{-89.95,184.05},{-89.95,184},{20,184},{20,90},{12,90}},
      color={255,204,51},
      thickness=0.5,
      pattern=LinePattern.Dash),
                      Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(MassFLow.y, pumCW.m_flow_in) annotation (Line(
      points={{-139,90},{-54,90},{-54,100},{-40,100},{-40,95.6}},
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
  connect(TCWRet.T, anti_freeze.TCWRet) annotation (Line(
      points={{91,50},{96,50},{96,104},{-170,104},{-170,117},{-162,117}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(anti_freeze.yMainValve, MainValve.y) annotation (Line(
      points={{-139,126},{32,126},{32,93.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(anti_freeze.yBypass, Bypass.y) annotation (Line(
      points={{-139,119},{-66,119},{-66,67.2},{0,67.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TAirRet.T, ahuCon.TAirRet) annotation (Line(
      points={{-9,-64},{-4,-64},{-4,-92},{-172,-92},{-172,-26},{-162,-26}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TAirSup.T, ahuCon.TAirSup) annotation (Line(
      points={{-91,-64},{-162,-64},{-162,-42}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ahuCon.uVal, AHU.uVal) annotation (Line(
      points={{-139,-23},{-82,-23},{-82,-30},{-61,-30}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ahuCon.XSet_w, AHU.XSet_w) annotation (Line(
      points={{-139,-31},{-84,-31},{-84,-33},{-61,-33}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ahuCon.TSet, AHU.TSet) annotation (Line(
      points={{-139,-34.4},{-86,-34.4},{-86,-35},{-61,-35}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ahuCon.uFan, AHU.uFan) annotation (Line(
      points={{-139,-38},{-61,-38}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(qflow.yAir, simplifiedRoom.u) annotation (Line(
      points={{-139,-107.2},{-70,-107.2},{-70,-74},{-60,-74}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(qflow.yLiq, D2C.u) annotation (Line(
      points={{-139,-111},{39.75,-111},{39.75,-73.9375}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCDUEnt.T, mixCon.TCDUEnt) annotation (Line(
      points={{11,-34.6},{11,-38},{10,-38},{10,-50},{-172,-50},{-172,1},{-162,1}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(mixCon.uVal, Mix.y) annotation (Line(
      points={{-139,7},{-96,7},{-96,6},{-40,6},{-40,-2.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cWpumCon.uCWpum, pumCHW.m_flow_in) annotation (Line(
      points={{-139,55},{-40,55},{-40,29.6}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCHWRet.T, cWpumCon.TCHWRet) annotation (Line(
      points={{91,0},{100,0},{100,-140},{-180,-140},{-180,51},{-162,51}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(cTCon.uFan, WCT.y) annotation (Line(
      points={{-139,150},{12,150},{12,94}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TCWRet.T, cTCon.TCWRet) annotation (Line(
      points={{91,50},{96,50},{96,104},{-170,104},{-170,150},{-162,150}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{-140,184},{-90,184}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaData.weaBus, cTCon.weaBus) annotation (Line(
      points={{-140,184},{-134,184},{-134,156},{-140,156}},
      color={255,204,51},
      thickness=0.5));
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
