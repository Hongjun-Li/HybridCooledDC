within DataCentersConfigurations.Examples.obsolete;
model WorkingFile
parameter Real tcwsupset  = 273.15 + 3 "Condensor Water Supply Setpoint Temperature";
  parameter Real tchwsupset = 273.15 + 12 "Chilled Water Supply Setpoint Temperature";
  parameter Real tairsupset = 273.15 + 18 "Air Supply Setpoint Temperature";
  parameter Real tairretset = 273.15 + 25 "Air Return Setpoint Temperature";
  parameter Real tcdusupset = 273.15 + 32 "CDU Supply Setpoint Temperature";
  parameter Real tcduretset = 273.15 + 55 "CDU Return Setpoint Temperature";
 package MediumW = Buildings.Media.Water "Medium model";
   parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=3*10.35
    "Nominal mass flow rate at evaporator";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=1*19.24
    "Nominal mass flow rate at condenser";
  parameter Modelica.Units.SI.Pressure dp1_nominal=60000
    "Nominal pressure difference on medium 1 side";
  parameter Modelica.Units.SI.Pressure dp2_nominal=60000
    "Nominal pressure difference on medium 2 side";
    // Chiller parameters
  parameter Modelica.Units.SI.MassFlowRate m1_flow_chi_nominal=19.24
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_chi_nominal=5*10.35
    "Nominal mass flow rate at evaporator water in the chillers";
  parameter Modelica.Units.SI.PressureDifference dp1_chi_nominal=30*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dp2_chi_nominal=30*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.Power QEva_nominal=m2_flow_chi_nominal*4200*(8.89
       - 26.67) "Nominal cooling capaciaty(Negative means cooling)";
 // WSE parameters
  parameter Modelica.Units.SI.MassFlowRate m1_flow_wse_nominal=3*10.35
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_wse_nominal=5*10.35
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.PressureDifference dp1_wse_nominal=33.1*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dp2_wse_nominal=5*34.5*1000
    "Nominal pressure";
  parameter Real mAirnominal=20;
  Controls.obsolete.Overall.OverallControl overallControl(
    tcwsupset=tcwsupset,
    tfreeze=273.15 + 6,
    tchwsupset=tchwsupset,
    tairsupset=tairsupset,
    tairretset=tairretset,
    tcdusupset=tcdusupset,
    tcduretset=tcduretset)
    annotation (Placement(transformation(extent={{-60,0},{-40,60}})));
  Modelica.Blocks.Sources.Constant const(k=2)
    annotation (Placement(transformation(extent={{-76,54},{-68,62}})));
  Architecture.obsolete.Simplified simplified(
    tchwsupset=tchwsupset,
    tairsupset=tairsupset,
    tairretset=tairretset,
    tcdusupset=tcdusupset,
    tcduretset=tcduretset,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    m1_flow_chi_nominal=m1_flow_chi_nominal,
    m2_flow_chi_nominal=m2_flow_chi_nominal,
    m1_flow_wse_nominal=m1_flow_wse_nominal,
    m2_flow_wse_nominal=m2_flow_wse_nominal,
    mAir_flow_nominal=300)
    annotation (Placement(transformation(extent={{-20,0},{0,60}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3
    weaDat(filNam="D:/Github/DataCenterArchitecture/weather/8.mos")
           annotation (Placement(transformation(extent={{56,44},{36,64}})));
equation
  connect(const.y, overallControl.u) annotation (Line(points={{-67.6,58},{-68,
          58.125},{-60,58.125}}, color={0,0,127}));
  connect(overallControl.CTbypass, simplified.CTBypass)
    annotation (Line(points={{-39.6,55.5},{-30,55.5},{-30,56.0625},{-20.0714,
          56.0625}},                                        color={0,0,127}));
  connect(overallControl.WCT, simplified.WCTv)
    annotation (Line(points={{-39.6,55.5},{-30,55.5},{-30,56.0625},{-20.0714,
          56.0625}},                                        color={0,0,127}));
  connect(overallControl.DCT, simplified.DCTv)
    annotation (Line(points={{-39.6,55.5},{-30,55.5},{-30,56.0625},{-20.0714,
          56.0625}},                                        color={0,0,127}));
  connect(overallControl.CTFan, simplified.CTFan)
    annotation (Line(points={{-39.6,55.5},{-30,55.5},{-30,56.0625},{-20.0714,
          56.0625}},                                        color={0,0,127}));
  connect(overallControl.val[3], simplified.v4) annotation (Line(points={{-39.8,
          38.4643},{-39.8,41.4375},{-20.0714,41.4375}},
                                                      color={0,0,127}));
  connect(overallControl.ChiOn, simplified.ChiOn) annotation (Line(points={{-39.6,
          32.625},{-39.6,36.1875},{-20.2143,36.1875}},   color={255,0,255}));
  connect(overallControl.WSEOn, simplified.WSEOn) annotation (Line(points={{-39.6,
          32.625},{-36,32.625},{-36,32},{-20.2143,32},{-20.2143,36.1875}},
        color={255,0,255}));
  connect(overallControl.CHWpump, simplified.CHWpump) annotation (Line(points={{-39.6,
          25.875},{-39.6,30.1875},{-20.0714,30.1875}},      color={0,0,127}));
  connect(overallControl.WSEbypass, simplified.WSEbypass) annotation (Line(
        points={{-39.6,25.875},{-22,25.875},{-22,26},{-20.0714,26},{-20.0714,
          30.1875}}, color={0,0,127}));
  connect(overallControl.Chibypass, simplified.Chibypass) annotation (Line(
        points={{-39.6,25.875},{-24,25.875},{-24,26},{-20.0714,26},{-20.0714,
          30.1875}}, color={0,0,127}));
  connect(overallControl.tchwsup, simplified.Tset) annotation (Line(points={{-39.6,
          25.875},{-32,25.875},{-32,30.1875},{-20.0714,30.1875}},       color={
          0,0,127}));
  connect(overallControl.AHUbypass, simplified.AHUbypass) annotation (Line(
        points={{-39.6,16.875},{-39.6,22.3125},{-20.0714,22.3125}},
                                                                  color={0,0,
          127}));
  connect(overallControl.AHUfan, simplified.AHUfan) annotation (Line(points={{-39.6,
          16.875},{-36,16.875},{-36,15.9375},{-20.0714,15.9375}},       color={
          0,0,127}));
  connect(overallControl.ITAir, simplified.ITAir) annotation (Line(points={{-39.6,
          7.125},{-39.6,13.6875},{-20.0714,13.6875}},     color={0,0,127}));
  connect(overallControl.ITLiquid, simplified.ITLiquid) annotation (Line(points={{-39.6,
          7.125},{-36,7.125},{-36,13.6875},{-20.0714,13.6875}},        color={0,
          0,127}));
  connect(overallControl.CDUactivate, simplified.CDUactivate) annotation (Line(
        points={{-39.6,7.125},{-36,7.125},{-36,13.6875},{-20.0714,13.6875}},
        color={0,0,127}));
  connect(overallControl.tchwret, simplified.tchwret) annotation (Line(points={{-56.4,
          0.375},{-56.4,-18},{18,-18},{18,48.75},{0.142857,48.75}},
        color={0,0,127}));
  connect(overallControl.TCWSup, simplified.tcwsup) annotation (Line(points={{-54.4,
          0.375},{-54.4,-16},{16,-16},{16,43.125},{0.142857,43.125}},   color={0,
          0,127}));
  connect(simplified.tcwret, overallControl.TCWRet) annotation (Line(points={{
          0.142857,35.625},{14,35.625},{14,-14},{-52.2,-14},{-52.2,0.375}},
                                                                     color={0,0,
          127}));
  connect(overallControl.Tsup, simplified.tairsup) annotation (Line(points={{-50,
          0.375},{-50,-12},{12,-12},{12,28.125},{0.142857,28.125}},   color={0,0,
          127}));
  connect(overallControl.Tret, simplified.tairret) annotation (Line(points={{-48,
          0.375},{-48,-10},{10,-10},{10,20.625},{0.142857,20.625}},
                                                            color={0,0,127}));
  connect(simplified.dp, overallControl.dp) annotation (Line(points={{0.142857,
          13.125},{8,13.125},{8,-8},{-46,-8},{-46,0.375}},
                                                    color={0,0,127}));
  connect(simplified.weaBus, weaDat.weaBus) annotation (Line(
      points={{-3.42857,59.25},{30,59.25},{30,54},{36,54}},
      color={255,204,51},
      thickness=0.5));
  connect(simplified.tdb, overallControl.tdrybulb) annotation (Line(points={{
          0.142857,53.625},{20,53.625},{20,-20},{-58.2,-20},{-58.2,0.375}},
        color={0,0,127}));
  connect(overallControl.ASE, simplified.ASE) annotation (Line(points={{-39.6,
          16.875},{-36,16.875},{-36,25.6875},{-20.0714,25.6875}}, color={0,0,
          127}));
  connect(simplified.tmix, overallControl.tmix) annotation (Line(points={{
          0.142857,13.125},{4,13.125},{4,-8},{-60,-8},{-60,0.375},{-59.8,0.375}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, __Dymola_Algorithm="Dassl"));
end WorkingFile;
