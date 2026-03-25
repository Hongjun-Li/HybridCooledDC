within Buildings.Applications.DataCenters.ChillerCooled.Examples.BaseClasses;
partial model PartialDataCenterLiquidCooling
  "Partial model that impliments cooling system for data centers"
  replaceable package MediumA = Buildings.Media.Air "Medium model";
  replaceable package MediumW = Buildings.Media.Water "Medium model";

  // Chiller parameters
  parameter Integer numChi=2 "Number of chillers";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_chi_nominal=34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_chi_nominal=18.3
    "Nominal mass flow rate at evaporator water in the chillers";
  parameter Modelica.Units.SI.PressureDifference dp1_chi_nominal=46.2*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dp2_chi_nominal=44.8*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.Power QEva_nominal=m2_flow_chi_nominal*4200*(6.67
       - 18.56) "Nominal cooling capaciaty(Negative means cooling)";
 // WSE parameters
  parameter Modelica.Units.SI.MassFlowRate m1_flow_wse_nominal=34.7
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_wse_nominal=35.3
    "Nominal mass flow rate at condenser water in the chillers";
  parameter Modelica.Units.SI.PressureDifference dp1_wse_nominal=33.1*1000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dp2_wse_nominal=34.5*1000
    "Nominal pressure";

  parameter Buildings.Fluid.Movers.Data.Generic[numChi] perPumCW(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=m1_flow_chi_nominal/1000*{0.2,0.6,1.0,1.2},
          dp=(dp1_chi_nominal+60000+6000)*{1.2,1.1,1.0,0.6}))
    "Performance data for condenser water pumps";
  parameter Modelica.Units.SI.Time tWai=1200 "Waiting time";

  // AHU
  parameter Modelica.Units.SI.ThermalConductance UA_nominal=numChi*QEva_nominal
      /Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
      6.67,
      11.56,
      12,
      25)
    "Thermal conductance at nominal flow for sensible heat, used to compute time constant";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=161.35
    "Nominal air mass flowrate";
  parameter Real yValMinAHU(min=0,max=1,unit="1")=0.1
    "Minimum valve openning position";
  // Set point
  parameter Modelica.Units.SI.Temperature TCHWSet=273.15 + 8
    "Chilled water temperature setpoint";
  parameter Modelica.Units.SI.Temperature TSupAirSet=TCHWSet + 10
    "Supply air temperature setpoint";
  parameter Modelica.Units.SI.Temperature TRetAirSet=273.15 + 25
    "Supply air temperature setpoint";
  parameter Modelica.Units.SI.Pressure dpSetPoi=80000
    "Differential pressure setpoint";

  replaceable
    Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialChillerWSE
    chiWSE(
    redeclare replaceable package Medium1 = MediumW,
    redeclare replaceable package Medium2 = MediumW,
    numChi=numChi,
    m1_flow_chi_nominal=m1_flow_chi_nominal,
    m2_flow_chi_nominal=m2_flow_chi_nominal,
    m1_flow_wse_nominal=m1_flow_wse_nominal,
    m2_flow_wse_nominal=m2_flow_wse_nominal,
    dp1_chi_nominal=dp1_chi_nominal,
    dp1_wse_nominal=dp1_wse_nominal,
    dp2_chi_nominal=dp2_chi_nominal,
    dp2_wse_nominal=dp2_wse_nominal,
    redeclare each
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YT_1055kW_5_96COP_Vanes
      perChi,
    use_strokeTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_controller=false) "Chillers and waterside economizer"
    annotation (Placement(transformation(extent={{4,48},{16,62}})));
  Buildings.Fluid.Sources.Boundary_pT expVesCW(
    redeclare replaceable package Medium = MediumW, nPorts=1)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-9,-9.5},{9,9.5}},
        rotation=180,
        origin={91,60.5})));
  Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow(
    redeclare each replaceable package Medium = MediumW,
    each TAirInWB_nominal(each displayUnit="degC") = 283.15,
    each TApp_nominal=6,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    each dp_nominal=30000,
    each m_flow_nominal=0.785*m1_flow_chi_nominal,
    each PFan_nominal=18000) "Cooling tower" annotation (Placement(
        transformation(extent={{10,-10},{-10,10}}, origin={10,140})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWSup(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-14,34},{-26,46}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3  weaData(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{120,188},{100,208}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{66,188},{86,208}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWSup(
    redeclare replaceable package Medium = MediumW, m_flow_nominal=
        m1_flow_chi_nominal)
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-20,130},{-40,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCWRet(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m1_flow_chi_nominal)
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCW(
    redeclare each replaceable package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each addPowerToMedium=false,
    per=perPumCW,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each use_riseTime=false) "Condenser water pump" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-48,100})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWRet(
    redeclare replaceable package Medium = MediumW,
    m_flow_nominal=numChi*m2_flow_chi_nominal)
    "Chilled water return temperature"
    annotation (Placement(transformation(extent={{46,34},{34,46}})));
  Buildings.Fluid.Sources.Boundary_pT expVesChi(
    redeclare replaceable package Medium = MediumW)
    "Expansion tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={90,19})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare replaceable package Medium =MediumW)
    "Differential pressure"
    annotation (Placement(transformation(extent={{0,20},{20,0}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val(
    redeclare each package Medium = MediumW,
    each m_flow_nominal=m1_flow_chi_nominal,
    each dpValve_nominal=6000,
    each use_strokeTime=false) "Shutoff valves"
    annotation (Placement(transformation(extent={{60,130},{40,150}})));

  Buildings.Controls.Continuous.LimPID CDUSpeCon(
    k=0.1,
    Ti=120,
    reverseActing=false,
    yMin=0.01)
            "Pump speed controller "
    annotation (Placement(transformation(extent={{-84,174},{-72,186}})));
  Modelica.Blocks.Sources.Constant TSupSetCT(k(
      unit="K",
      displayUnit="degC") = 273.15 + 6)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-122,170},{-102,190}})));
equation
  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{4,50.8},{-10,50.8},{-10,40},{-14,40}},
      color={0,127,255},
      thickness=0.5));
  for i in 1:numChi loop
  connect(weaBus.TWetBul, cooTow[i].TAir) annotation (Line(
      points={{76.05,198.05},{38,198.05},{38,144},{22,144}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  end for;

  connect(chiWSE.port_b2, TCHWSup.port_a)
    annotation (Line(
      points={{4,50.8},{-10,50.8},{-10,40},{-14,40}},
      color={0,127,255},
      thickness=0.5));
   for i in 1:numChi loop
   end for;

  connect(weaData.weaBus, weaBus) annotation (Line(
      points={{100,198},{76,198}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));

  for i in 1:numChi loop
  end for;
  connect(TCWSup.T, CDUSpeCon.u_m) annotation (Line(points={{-30,151},{-30,160},
          {-78,160},{-78,172.8}}, color={0,0,127}));
  connect(TSupSetCT.y, CDUSpeCon.u_s)
    annotation (Line(points={{-101,180},{-85.2,180}}, color={0,0,127}));
  connect(CDUSpeCon.y, cooTow[numChi].y) annotation (Line(points={{-71.4,180},{
          26,180},{26,150},{22,150},{22,148}}, color={0,0,127}));
  connect(val[numChi].y, CDUSpeCon.y)
    annotation (Line(points={{50,152},{50,180},{-71.4,180}}, color={0,0,127}));
  connect(TCWRet.port_b, val.port_a) annotation (Line(points={{60,60},{66,60},{
          66,140},{60,140}}, color={0,127,255}));
  connect(expVesCW.ports[1], val.port_a) annotation (Line(points={{82,60.5},{74,
          60.5},{74,60},{66,60},{66,140},{60,140}}, color={0,127,255}));
  connect(TCWRet.port_a, chiWSE.port_b1)
    annotation (Line(points={{40,60},{38,59.2},{16,59.2}}, color={0,127,255}));
  connect(pumCW.port_b, chiWSE.port_a1) annotation (Line(points={{-48,90},{-48,
          59.2},{4,59.2}}, color={0,127,255}));
  connect(TCWSup.port_a, cooTow.port_b)
    annotation (Line(points={{-20,140},{0,140}}, color={0,127,255}));
  connect(cooTow.port_a, val.port_b)
    annotation (Line(points={{20,140},{40,140}}, color={0,127,255}));
  connect(TCWSup.port_b, pumCW.port_a) annotation (Line(points={{-40,140},{-48,
          140},{-48,110}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-360,-200},{160,260}})),
    Documentation(info="<html>
<p>
This is a partial model that describes the chilled water cooling system in a data center. The sizing data
are collected from the reference.
</p>
<h4>Reference </h4>
<ul>
<li>
Taylor, S. T. (2014). How to design &amp; control waterside economizers. ASHRAE Journal, 56(6), 30-36.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 3, 2024, by Jianjun Hu:<br/>
Added plant on signal to control the pump speed.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3989\">issue 3989</a>.
</li>
<li>
January 2, 2022, by Kathryn Hinkelman:<br/>
Passed the <code>plaOn</code> signal to the chilled water pump control
to turn them off when the plant is off.
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Corrected control to avoid cooling tower pumps to operate when plant is off, because
shut-off valves are off when plant is off.
</li>
<li>
November 1, 2021, by Michael Wetter:<br/>
Corrected weather data bus connection which was structurally incorrect
and did not parse in OpenModelica.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2706\">issue 2706</a>.
</li>
<li>
October 6, 2020, by Michael Wetter:<br/>
Set <code>val.use_inputFilter=false</code> because pump worked against closed valve at <i>t=60</i> seconds,
leading to negative pressure at pump inlet (because pump forces the mass flow rate).
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Removed wrong <code>each</code>.
</li>
<li>
December 1, 2017, by Yangyang Fu:<br/>
Used scaled differential pressure to control the speed of pumps. This can avoid retuning gains
in PID when changing the differential pressure setpoint.
</li>
<li>
September 2, 2017, by Michael Wetter:<br/>
Changed expansion vessel to use the more efficient implementation.
</li>
<li>
July 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-360,-200},{160,260}})));
end PartialDataCenterLiquidCooling;
