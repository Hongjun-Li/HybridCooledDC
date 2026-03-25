within DataCentersConfigurations.Controls.TrimandResponse;
model Control
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
  parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal=2*ITLoad/(
      4200*20) "Nominal mass flow rate at chilled water";

  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal=2*ITLoad/(
      4200*6) "Nominal mass flow rate at condenser water";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=500
    "Nominal pressure difference";
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.WSEControl wseCon
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={0,-7})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.ChillerSwitch chiSwi(deaBan(
        displayUnit="K") = 2.2) "Control unit switching chiller on or off "
    annotation (Placement(transformation(extent={{-64,38},{-52,49}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.LinearPiecewiseTwo
    linPieTwo(
    x0=0,
    x2=1,
    x1=0.5,
    y11=1,
    y21=273.15 + 5.56,
    y10=0.2,
    y20=273.15 + 22) "Translate the control signal for chiller setpoint reset"
    annotation (Placement(transformation(extent={{-32,84},{-20,96}})));
  Modelica.Blocks.Math.BooleanToReal chiCon "Contorl signal for chiller"
    annotation (Placement(transformation(extent={{-26,26},{-14,38}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.KMinusU KMinusU(k=1)
    annotation (Placement(transformation(extent={{-6,16},{6,28}})));
  Modelica.Blocks.Math.Gain gain(k=20*6485)
    annotation (Placement(transformation(extent={{0,56},{8,64}})));
  Modelica.Blocks.Math.Feedback feedback
    annotation (Placement(transformation(extent={{-82,80},{-62,100}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold
    annotation (Placement(transformation(extent={{22,94},{34,106}})));
  Modelica.Blocks.Logical.Or or1
    annotation (Placement(transformation(extent={{44,94},{56,106}})));
  Modelica.Blocks.Math.BooleanToReal mCWFlo(realTrue=mCW_flow_nominal)
    "Mass flow rate of condenser loop"
    annotation (Placement(transformation(extent={{62,94},{74,106}})));
  Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespondContinuousTimeApproximation
    triAndRes
    "Continuous time approximation for trim and respond controller"
    annotation (Placement(transformation(extent={{-54,84},{-42,96}})));
  Buildings.BoundaryConditions.WeatherData.Bus
                                     weaBus
    annotation (Placement(transformation(extent={{-110,84},{-90,104}}),
        iconTransformation(extent={{-110,84},{-90,104}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Control
    annotation (Placement(transformation(extent={{80,-20},{120,20}}),
        iconTransformation(extent={{92,-8},{112,12}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{-20,-140},{20,-100}}),
        iconTransformation(extent={{-10,-112},{10,-92}})));
  CW.CT bypassConContrinuosModular
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}}),
        iconTransformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Sources.Constant const(k=273.15 + 14)
    annotation (Placement(transformation(extent={{-88,74},{-82,80}})));
  Modelica.Blocks.Sources.Constant const1(k=TAppNominal)
    annotation (Placement(transformation(extent={{-38,-16},{-32,-10}})));
  Modelica.Blocks.Sources.Constant const2(k=TCWsupset)
    annotation (Placement(transformation(extent={{-40,-34},{-34,-28}})));
  Modelica.Blocks.Sources.Constant const3(k=TFreeze)
    annotation (Placement(transformation(extent={{-38,-46},{-32,-40}})));
  IT.ITSplit iTSplit
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));
  CHW.Modulation modulation
    annotation (Placement(transformation(extent={{-62,28},{-54,36}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean(threshold=0.5)
    annotation (Placement(transformation(extent={{-50,28},{-46,32}})));
  Modelica.Blocks.MathBoolean.And and1(nu=2)
    annotation (Placement(transformation(extent={{-42,38},{-34,46}})));
  AHU_CDU.AHU_CDU aHU_CDU
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));
  Buildings.Controls.Continuous.LimPID
                             conFan(
    k=1,
    Ti=60,
    Td=10,
    initType=Modelica.Blocks.Types.Init.InitialState,
    reverseActing=false)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-76,106},{-68,114}})));
  Modelica.Blocks.Sources.Constant const4(k=273.15 + 18)
    annotation (Placement(transformation(extent={{-90,108},{-84,114}})));
equation
  connect(or1.u1,greaterThreshold. y) annotation (Line(
      points={{42.8,100},{34.6,100}},
      color={255,0,255},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(or1.y,mCWFlo. u) annotation (Line(
      points={{56.6,100},{60.8,100}},
      color={255,0,255},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(feedback.y,triAndRes. u) annotation (Line(
      points={{-63,90},{-55.2,90}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(triAndRes.y, linPieTwo.u)
    annotation (Line(points={{-41.4,90},{-33.2,90}}, color={0,0,127}));
  connect(KMinusU.u, chiCon.y) annotation (Line(points={{-7.08,22},{-10,22},{
          -10,32},{-13.4,32}},
                             color={0,0,127}));
  connect(weaBus.TWetBul, Control.Wetbulb) annotation (Line(
      points={{-99.95,94.05},{-99.95,0},{-100,0},{-100,-114},{100,-114},{100,0}},
      color={255,204,51},
      thickness=0.5));
  connect(linPieTwo.y[2], Control.CHWSupSet) annotation (Line(
      points={{-19.4,90.03},{-10,90.03},{-10,110},{80,110},{80,0},{100,0}},
      color={0,140,72}));
  connect(chiSwi.TSet, linPieTwo.y[1]) annotation (Line(points={{-64.6,40.75},{
          -68,40.75},{-68,60},{-10,60},{-10,89.73},{-19.4,89.73}},
                                                               color={0,0,127}));
  connect(chiSwi.chiCHWST, Temperature.TChiEnter) annotation (Line(
      points={{-64.6,47.35},{-92,47.35},{-92,-120},{0,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(wseCon.TWetBul, weaBus.TWetBul) annotation (Line(
      points={{-12,-6.41176},{-92,-6.41176},{-92,94.05},{-99.95,94.05}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(wseCon.wseCWST, Temperature.TCWSup) annotation (Line(
      points={{-12,-14.5294},{-12,-14},{-16,-14},{-16,-18},{-92,-18},{-92,-120},
          {0,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(wseCon.wseCHWST, Temperature.TCHWRet) annotation (Line(
      points={{-12,-1.70588},{-12,-2},{-92,-2},{-92,-120},{0,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chiCon.y, Control.ValveChi) annotation (Line(
      points={{-13.4,32},{80,32},{80,0},{100,0}},
      color={0,140,72}));
  connect(KMinusU.y, Control.ChiBypass) annotation (Line(
      points={{6.6,22},{80,22},{80,0},{100,0}},
      color={0,140,72}));
  connect(wseCon.y1, Control.ValveWSE) annotation (Line(
      points={{11,-5.23529},{80,-5.23529},{80,0},{100,0}},
      color={0,140,72}));
  connect(wseCon.y2, Control.WSEBypass) annotation (Line(
      points={{11,-9.94118},{80,-9.94118},{80,0},{100,0}},
      color={0,140,72}));
  connect(gain.u, linPieTwo.y[1]) annotation (Line(points={{-0.8,60},{-10,60},{
          -10,89.73},{-19.4,89.73}},
                                 color={0,0,127}));
  connect(gain.y, Control.PumpCHW) annotation (Line(
      points={{8.4,60},{80,60},{80,0},{100,0}},
      color={0,140,72}));
  connect(greaterThreshold.u, wseCon.y1) annotation (Line(points={{20.8,100},{
          16,100},{16,-5.23529},{11,-5.23529}},
                                             color={0,0,127}));
  connect(mCWFlo.y, Control.PumpCW) annotation (Line(
      points={{74.6,100},{80,100},{80,0},{100,0}},
      color={0,140,72}));
  connect(bypassConContrinuosModular.TCWRet, Temperature.TCWRet) annotation (
      Line(points={{-12,-47.1},{-12,-48},{-92,-48},{-92,-120},{0,-120}},
                                                                       color={0,
          0,127},
      pattern=LinePattern.Dash));
  connect(bypassConContrinuosModular.TCWSup, Temperature.TCWSup) annotation (
      Line(points={{-12,-37.9},{-92,-37.9},{-92,-120},{0,-120}},color={0,0,127},
      pattern=LinePattern.Dash));
  connect(bypassConContrinuosModular.CTFan, Control.CTFan) annotation (Line(
        points={{11,-30},{80,-30},{80,0},{100,0}},     color={0,140,72}));
  connect(bypassConContrinuosModular.WCT, Control.ValveWCT) annotation (Line(
        points={{11,-40},{80,-40},{80,0},{100,0}},     color={0,140,72}));
  connect(bypassConContrinuosModular.bypass, Control.CWBypass) annotation (Line(
        points={{11,-43},{80,-43},{80,0},{100,0}}, color={0,140,72}));
  connect(u, bypassConContrinuosModular.Archi_Selection) annotation (Line(
        points={{-106,0},{-80,0},{-80,-28.3},{-12,-28.3}},
        color={217,67,180},
      thickness=0.5));
  connect(const.y, feedback.u2)
    annotation (Line(points={{-81.7,77},{-72,77},{-72,82}}, color={0,0,127}));
  connect(const1.y, wseCon.towTApp) annotation (Line(points={{-31.7,-13},{-20,
          -13},{-20,-9.94118},{-12,-9.94118}},
                                        color={0,0,127}));
  connect(const2.y, bypassConContrinuosModular.TCWSupSet) annotation (Line(
        points={{-33.7,-31},{-33.7,-30},{-20,-30},{-20,-33.3},{-12,-33.3}},
                                                                          color
        ={0,0,127}));
  connect(const3.y, bypassConContrinuosModular.TCWRetSet) annotation (Line(
        points={{-31.7,-43},{-28,-43},{-28,-42.7},{-12,-42.7}},
        color={0,0,127}));
  connect(iTSplit.y[1], Control.ITLoadAir) annotation (Line(
      points={{10.6,-62.25},{80,-62.25},{80,0},{100,0}},
      color={0,140,72}));
  connect(iTSplit.u, u) annotation (Line(points={{-10,-53},{-80,-53},{-80,0},{
          -106,0}},   color={217,67,180},
      thickness=0.5));
  connect(wseCon.Architecture, u) annotation (Line(points={{-12,1.82353},{-12,2},
          {-80,2},{-80,0},{-106,0}},      color={217,67,180},
      thickness=0.5));
  connect(modulation.u, u) annotation (Line(points={{-62,32},{-80,32},{-80,0},{
          -106,0}}, color={217,67,180},
      thickness=0.5));
  connect(modulation.ChiActivate, realToBoolean.u) annotation (Line(points={{-53.76,
          30.4},{-53.76,30},{-50.4,30}},        color={0,0,127}));
  connect(realToBoolean.y, and1.u[1]) annotation (Line(points={{-45.8,30},{-46,
          30},{-46,41.3},{-42,41.3}}, color={255,0,255}));
  connect(chiSwi.y, and1.u[2]) annotation (Line(points={{-51.4,43.17},{-44,
          43.17},{-44,42.7},{-42,42.7}}, color={255,0,255}));
  connect(and1.y, chiCon.u) annotation (Line(points={{-33.4,42},{-30,42},{-30,
          32},{-27.2,32}}, color={255,0,255}));
  connect(and1.y, or1.u2) annotation (Line(points={{-33.4,42},{36,42},{36,95.2},
          {42.8,95.2}}, color={255,0,255}));
  connect(and1.y, Control.ChiOn) annotation (Line(
      points={{-33.4,42},{80,42},{80,0},{100,0}},
      color={0,140,72}));
  connect(weaBus.TDryBul, Control.Drybulb) annotation (Line(
      points={{-99.95,94.05},{-100,94.05},{-100,-114},{100,-114},{100,0}},
      color={255,204,51},
      thickness=0.5));
  connect(bypassConContrinuosModular.DCT, Control.ValveDCT) annotation (Line(
      points={{11,-36},{80,-36},{80,0},{100,0}},
      color={0,140,72}));
  connect(bypassConContrinuosModular.DCTFan, Control.DCTFan) annotation (Line(
      points={{11,-33},{80,-33},{80,0},{100,0}},
      color={0,140,72}));
  connect(aHU_CDU.u, u) annotation (Line(
      points={{-10.6,-90},{-80,-90},{-80,0},{-106,0}},
      color={217,67,180},
      thickness=0.5));
  connect(aHU_CDU.CDU_Bypass, Control.CDUBypass) annotation (Line(points={{10.6,
          -96},{80,-96},{80,0},{100,0}}, color={0,140,72}));
  connect(aHU_CDU.CDU_Activate, Control.CDUActivate) annotation (Line(points={{
          10.6,-94},{80,-94},{80,0},{100,0}}, color={0,140,72}));
  connect(iTSplit.y[2], Control.ITLoadCDU) annotation (Line(points={{10.6,
          -61.75},{80,-61.75},{80,0},{100,0}}, color={0,140,72}));
  connect(feedback.u1, Temperature.TCHWSup) annotation (Line(
      points={{-80,90},{-92,90},{-92,-120},{0,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conFan.y, Control.AHUFan) annotation (Line(points={{-67.6,110},{80,
          110},{80,0},{100,0}}, color={0,140,72}));
  connect(const4.y, conFan.u_s) annotation (Line(points={{-83.7,111},{-83.7,110},
          {-76.8,110}}, color={0,0,127}));
  connect(conFan.u_m, Temperature.TAirRet) annotation (Line(
      points={{-72,105.2},{-72,102},{-92,102},{-92,-120},{0,-120}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(aHU_CDU.AHU_Bypass, Control.AHUBypass) annotation (Line(points={{10.6,
          -84},{80,-84},{80,0},{100,0}}, color={0,140,72}));
  connect(aHU_CDU.AHU_Activate, Control.AHUActivate) annotation (Line(points={{
          10.6,-86},{80,-86},{80,0},{100,0}}, color={0,140,72}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -120},{100,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            120}})));
end Control;
