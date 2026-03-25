within DataCentersConfigurations.Controls.TrimandResponse;
model ChiWSE
  parameter Real TAirset = 273.15 + 18 "[K]";
  parameter Real TFreeze=273.15 + 3 "[K]";
  parameter Real TCHWsupset = 273.15 + 14 "[K]";
  parameter Real TAppNominal = 6 "[K]";
  parameter Real ITLoad = 500000 "[W]";

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=ITLoad/(
      1005*7.25) "Nominal mass flow rate at fan";

  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal= ITLoad/(
      4200*20) "Nominal mass flow rate at condenser water";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=500
    "Nominal pressure difference";
  Buildings.BoundaryConditions.WeatherData.Bus
                                     weaBus
    annotation (Placement(transformation(extent={{-110,90},{-90,110}}),
        iconTransformation(extent={{-110,90},{-90,110}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Control
    annotation (Placement(transformation(extent={{26,-16},{56,16}}),
        iconTransformation(extent={{92,-8},{112,12}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{-28,-132},{2,-98}}),
        iconTransformation(extent={{-10,-112},{10,-92}})));
  DataCentersConfigurations.Controls.CW.CW CW(CW_flownominal=mCW_flow_nominal)
    annotation (Placement(transformation(extent={{-22,64},{-2,88}})));
  Modelica.Blocks.Interfaces.RealInput u
    annotation (Placement(transformation(extent={{-126,-20},{-86,20}}),
        iconTransformation(extent={{-126,-20},{-86,20}})));
  Modelica.Blocks.Sources.Constant const3(k=TFreeze)
    annotation (Placement(transformation(extent={{-30,70},{-26,74}})));
  IT.ITSplit iTSplit
    annotation (Placement(transformation(extent={{-22,-98},{-2,-78}})));
  AHU_CDU.AHU_CDU aHU_CDU
    annotation (Placement(transformation(extent={{-22,-68},{-2,-48}})));
  Modelica.Blocks.Sources.Constant TAppTow(k=TAppNominal)
                                                "Cooling tower approach"
    annotation (Placement(transformation(extent={{-30,0},{-26,4}})));
  CHW.ChiWSE chiWSE
    annotation (Placement(transformation(extent={{-22,-10},{-2,10}})));
  Modelica.Blocks.Sources.RealExpression TCWWet(y=min(23.89 + 273.15, max(
        273.15 + 12.78, weaBus.TWetBul + 3)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-56,78},{-50,84}})));
  Modelica.Blocks.Sources.RealExpression TCWDry(y=min(23.89 + 273.15, max(
        273.15 + 12.78, weaBus.TDryBul + 3)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-56,72},{-50,78}})));
  Valve.Selection selection
    annotation (Placement(transformation(extent={{-48,72},{-40,84}})));
equation
  connect(weaBus.TWetBul, Control.Wetbulb) annotation (Line(
      points={{-99.95,100.05},{-99.95,8},{-100,8},{-100,-106},{41,-106},{41,0}},
      color={255,204,51},
      thickness=0.5));
  connect(CW.TCWRet, Temperature.TCWRet) annotation (
      Line(points={{-23.2,66.4},{-23.2,66},{-32,66},{-32,-115},{-13,-115}},
                                                                       color={0,0,0},
      thickness=0.5));
  connect(CW.TCWSup, Temperature.TCWSup) annotation (
      Line(points={{-23.2,76},{-32,76},{-32,-115},{-13,-115}},  color={0,0,0},
      thickness=0.5));
  connect(u, CW.Archi_Selection) annotation (Line(
        points={{-106,0},{-62,0},{-62,85.6},{-23.2,85.6}},
        color={217,67,180},
      thickness=0.5));
  connect(const3.y, CW.TCWRetSet) annotation (Line(
        points={{-25.8,72},{-25.8,71.2},{-23.2,71.2}},
        color={0,0,127}));
  connect(iTSplit.y[1], Control.ITLoadAir) annotation (Line(
      points={{-1.4,-88.25},{8,-88.25},{8,0},{41,0}},
      color={0,140,72},
      thickness=0.5));
  connect(iTSplit.u, u) annotation (Line(points={{-22,-79},{-62,-79},{-62,0},{
          -106,0}},   color={217,67,180},
      thickness=0.5));
  connect(weaBus.TDryBul, Control.Drybulb) annotation (Line(
      points={{-99.95,100.05},{-100,100.05},{-100,-106},{41,-106},{41,0}},
      color={255,204,51},
      thickness=0.5));
  connect(aHU_CDU.u, u) annotation (Line(
      points={{-22.6,-58},{-62,-58},{-62,0},{-106,0}},
      color={217,67,180},
      thickness=0.5));
  connect(aHU_CDU.CDU_Bypass, Control.CDUBypass) annotation (Line(points={{-1.4,
          -64},{8,-64},{8,0},{41,0}},    color={0,140,72},
      thickness=0.5));
  connect(aHU_CDU.CDU_Activate, Control.CDUActivate) annotation (Line(points={{-1.4,
          -62},{8,-62},{8,0},{41,0}},         color={0,140,72},
      thickness=0.5));
  connect(iTSplit.y[2], Control.ITLoadCDU) annotation (Line(points={{-1.4,
          -87.75},{8,-87.75},{8,0},{41,0}},    color={0,140,72},
      thickness=0.5));
  connect(aHU_CDU.AHU_Bypass, Control.AHUBypass) annotation (Line(points={{-1.4,
          -52},{8,-52},{8,0},{41,0}},    color={0,140,72},
      thickness=0.5));
  connect(aHU_CDU.AHU_Activate, Control.AHUActivate) annotation (Line(points={{-1.4,
          -54},{8,-54},{8,0},{41,0}},         color={0,140,72},
      thickness=0.5));
  connect(CW.CTFan, Control.CTFan) annotation (Line(
      points={{-1,85.6},{8,85.6},{8,0},{41,0}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(CW.DCTFan, Control.DCTFan) annotation (Line(
      points={{-1,82},{8,82},{8,0},{41,0}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(CW.DCT, Control.ValveDCT) annotation (Line(
      points={{-1,78.4},{8,78.4},{8,0},{41,0}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(CW.WCT, Control.ValveWCT) annotation (Line(
      points={{-1,74.8},{8,74.8},{8,0},{41,0}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(CW.bypass, Control.CWBypass) annotation (Line(
      points={{-1,71.2},{8,71.2},{8,0},{41,0}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(CW.CWmassflow, Control.PumpCW) annotation (Line(
      points={{-1,67.6},{8,67.6},{8,0},{41,0}},
      color={238,46,47},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(TAppTow.y, chiWSE.TApp) annotation (Line(points={{-25.8,2},{-23,2}},
                         color={0,0,127}));
  connect(chiWSE.TCHWSupWSE, Temperature.TChiEnter) annotation (Line(
      points={{-23,-1},{-32,-1},{-32,-115},{-13,-115}},
      color={0,0,0},
      thickness=0.5));
  connect(chiWSE.TCHWRetWSE, Temperature.TCHWRet) annotation (Line(
      points={{-23,-4},{-32,-4},{-32,-115},{-13,-115}},
      color={0,0,0},
      thickness=0.5));
  connect(chiWSE.Chion, Control.ChiOn) annotation (Line(
      points={{-1.4,9},{-1.4,8},{8,8},{8,0},{41,0}},
      color={28,108,200},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(chiWSE.ChillerBypass, Control.ChiBypass) annotation (Line(
      points={{-1.4,6},{8,6},{8,0},{41,0}},
      color={28,108,200},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(chiWSE.ValveChi, Control.ValveChi) annotation (Line(
      points={{-1.4,3},{8,3},{8,0},{41,0}},
      color={28,108,200},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(chiWSE.ValveWSE, Control.ValveWSE) annotation (Line(
      points={{-1.4,0},{41,0}},
      color={28,108,200},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(chiWSE.CHWSupSet, Control.CHWSupSet) annotation (Line(
      points={{-1.4,-6},{8,-6},{8,0},{41,0}},
      color={28,108,200},
      pattern=LinePattern.Dash,
      thickness=0.5));
  connect(chiWSE.TCHWSup, Temperature.TCHWSup) annotation (Line(
      points={{-23,-7},{-32,-7},{-32,-115},{-13,-115}},
      color={0,0,0},
      thickness=0.5));
  connect(chiWSE.u, u) annotation (Line(points={{-23,5},{-62,5},{-62,0},{-106,0}},
        color={217,67,180},
      thickness=0.5));
  connect(weaBus, chiWSE.weaBus) annotation (Line(
      points={{-100,100},{-100,8},{-23.2,8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(aHU_CDU.AHU_TMeas, Temperature.TAirRet) annotation (Line(
      points={{-22.4,-51},{-22.4,-50},{-32,-50},{-32,-115},{-13,-115}},
      color={0,0,0},
      thickness=0.5));
  connect(aHU_CDU.AHU_Fan, Control.AHUFan) annotation (Line(
      points={{-1.4,-49.6},{8,-49.6},{8,0},{41,0}},
      color={0,140,72},
      thickness=0.5));
  connect(selection.TCWDry, TCWDry.y)
    annotation (Line(points={{-48,75},{-49.7,75}}, color={0,0,127}));
  connect(TCWWet.y, selection.TCWWet)
    annotation (Line(points={{-49.7,81},{-48,81}}, color={0,0,127}));
  connect(selection.V, CW.TCWSupSet) annotation (Line(points={{-39.84,78},{-36,
          78},{-36,80.8},{-23.2,80.8}}, color={0,0,127}));
  connect(selection.u, u) annotation (Line(
      points={{-48,78},{-62,78},{-62,0},{-106,0}},
      color={217,67,180},
      thickness=0.5));
  connect(chiWSE.mchw, Control.PumpCHW) annotation (Line(
      points={{-1.4,-9},{8,-9},{8,0},{41,0}},
      color={28,108,200},
      thickness=0.5,
      pattern=LinePattern.Dash));
  connect(chiWSE.WSEbypass, Control.WSEBypass) annotation (Line(
      points={{-1.4,-3},{8,-3},{8,0},{41,0}},
      color={28,108,200},
      thickness=0.5,
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -120},{100,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,
            120}})));
end ChiWSE;
