within DataCentersConfigurations.Controls.CW;
package Validation
  model DataCenterContinuousTimeControl
    "Model of data center that approximates the trim and respond logic"
    extends Buildings.Examples.ChillerPlant.BaseClasses.DataCenter(weaData(filNam=
            "D:/Github/DataCenterArchitecture/weather/3C.mos"));
    extends Modelica.Icons.Example;

    Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespondContinuousTimeApproximation
      triAndRes
      "Continuous time approximation for trim and respond controller"
      annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  equation
    connect(feedback.y, triAndRes.u) annotation (Line(
        points={{-191,200},{-182,200}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(triAndRes.y, linPieTwo.u) annotation (Line(
        points={{-159,200},{-122,200}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));

    annotation (
      __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/DataCenterContinuousTimeControl.mos"
          "Simulate and plot"), Documentation(info="<html>
<p>
This model is the chilled water plant with continuous time control.
The trim and respond logic is approximated by a PI controller which
significantly reduces computing time. The model is described at
<a href=\"modelica://Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl</a>
for an implementation with the discrete time trim and respond logic.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 13, 2015, by Michael Wetter:<br/>
Moved base model to
<a href=\"modelica://Buildings.Examples.ChillerPlant.BaseClasses.DataCenter\">
Buildings.Examples.ChillerPlant.BaseClasses.DataCenter</a>.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-300},{400,
              300}}), graphics),
      experiment(
        StopTime=86400,
        Tolerance=1e-06,
        __Dymola_Algorithm="Dassl"));
  end DataCenterContinuousTimeControl;

  model DataCenterContinuousTimeControlBypassContinuos
    "Model of data center that approximates the trim and respond logic with bypass"
    extends Buildings.Examples.ChillerPlant.BaseClasses.DataCenter(
      weaData(filNam="D:/Github/DataCenterArchitecture/weather/8.mos"),
      TAirSet(k=273.15 + 18),
      roo(QRoo_flow(displayUnit="kW") = 500000));
    extends Modelica.Icons.Example;

    Buildings.Examples.ChillerPlant.BaseClasses.Controls.TrimAndRespondContinuousTimeApproximation
      triAndRes
      "Continuous time approximation for trim and respond controller"
      annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
    Buildings.Fluid.FixedResistances.Junction jun(
      redeclare package Medium = MediumW,
      m_flow_nominal={mCW_flow_nominal,mCW_flow_nominal,-2*mCW_flow_nominal},
      dp_nominal={0,0,0})
      annotation (Placement(transformation(extent={{104,230},{124,250}})));
    Buildings.Fluid.Actuators.Valves.TwoWayLinear valbypass1(
      redeclare each package Medium = MediumW,
      each m_flow_nominal=mCW_flow_nominal,
      each dpValve_nominal=6000,
      each use_strokeTime=false) "Shutoff valves"
      annotation (Placement(transformation(extent={{222,230},{242,250}})));
    Buildings.Fluid.Actuators.Valves.TwoWayLinear valbypass2(
      redeclare each package Medium = MediumW,
      each m_flow_nominal=mCW_flow_nominal,
      each dpValve_nominal=6000,
      each use_strokeTime=false) "Shutoff valves"
      annotation (Placement(transformation(extent={{282,202},{302,222}})));
    Buildings.Fluid.Sensors.TemperatureTwoPort TCWAppTow(redeclare package
        Medium = MediumW, m_flow_nominal=mCW_flow_nominal)
      "Temperature of condenser water approaching the cooling tower"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin
            ={168,239})));
    Modelica.Blocks.Sources.Constant const(k=273.15 + 3)
      annotation (Placement(transformation(extent={{152,256},{162,266}})));
    Modelica.Blocks.Sources.Constant const1(k=273.15 + 8)
      annotation (Placement(transformation(extent={{152,272},{162,282}})));
    CT bypassConContrinuosModular
      annotation (Placement(transformation(extent={{180,262},{200,282}})));
    Modelica.Blocks.Sources.Constant const2(k=1)
      annotation (Placement(transformation(extent={{134,280},{144,290}})));
  equation
    connect(feedback.y, triAndRes.u) annotation (Line(
        points={{-191,200},{-182,200}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
    connect(triAndRes.y, linPieTwo.u) annotation (Line(
        points={{-159,200},{-122,200}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));

    connect(val4.port_b, jun.port_1) annotation (Line(points={{98,190},{98,
            240},{104,240}}, color={0,127,255}));
    connect(val5.port_b, jun.port_3) annotation (Line(points={{218,190},{218,
            204},{114,204},{114,230}}, color={0,127,255}));
    connect(valbypass1.port_b, cooTow.port_a) annotation (Line(points={{242,
            240},{244,239},{259,239}}, color={0,127,255}));
    connect(valbypass2.y, bypassConContrinuosModular.bypass) annotation (Line(
          points={{292,224},{292,268},{201,268}}, color={0,0,127}));
    connect(bypassConContrinuosModular.WCT, valbypass1.y) annotation (Line(
          points={{201,272.2},{232,272.2},{232,252}}, color={0,0,127}));
    connect(bypassConContrinuosModular.CTFan, cooTow.y) annotation (Line(
          points={{200.9,280.3},{240,280.3},{240,260},{257,260},{257,247}},
          color={0,0,127}));
    connect(bypassConContrinuosModular.TCWRet, TCWAppTow.T) annotation (Line(
          points={{178,262.9},{168,262.9},{168,250}}, color={0,0,127}));
    connect(const.y, bypassConContrinuosModular.TCWRetSet) annotation (Line(
          points={{162.5,261},{178,261},{178,267.3}}, color={0,0,127}));
    connect(bypassConContrinuosModular.TCWSup, cooTow.TLvg) annotation (Line(
          points={{178,272.1},{172,272.1},{172,296},{288,296},{288,233},{280,
            233}}, color={0,0,127}));
    connect(const1.y, bypassConContrinuosModular.TCWSupSet) annotation (Line(
          points={{162.5,277},{164,276.7},{178,276.7}}, color={0,0,127}));
    connect(const2.y, bypassConContrinuosModular.Archi_Selection) annotation
      (Line(points={{144.5,285},{144.5,284},{148,284},{148,288},{160,288},{
            160,292},{168,292},{168,284},{178,284},{178,281.7}}, color={0,0,
            127}));
    connect(cooTow.port_b, pumCW.port_a) annotation (Line(points={{279,239},{
            358,239},{358,210}}, color={0,127,255}));
    connect(valbypass2.port_b, pumCW.port_a) annotation (Line(points={{302,
            212},{308,212},{308,238},{314,238},{314,239},{358,239},{358,210}},
          color={0,127,255}));
    connect(valbypass1.port_a, TCWAppTow.port_b) annotation (Line(points={{
            222,240},{220,239},{178,239}}, color={0,127,255}));
    connect(TCWAppTow.port_b, valbypass2.port_a) annotation (Line(points={{
            178,239},{216,239},{216,212},{282,212}}, color={0,127,255}));
    connect(jun.port_2, TCWAppTow.port_a) annotation (Line(points={{124,240},
            {128,239},{158,239}}, color={0,127,255}));
    annotation (
      __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/DataCenterContinuousTimeControl.mos"
          "Simulate and plot"), Documentation(info="<html>
<p>
This model is the chilled water plant with continuous time control.
The trim and respond logic is approximated by a PI controller which
significantly reduces computing time. The model is described at
<a href=\"modelica://Buildings.Examples.ChillerPlant\">
Buildings.Examples.ChillerPlant</a>.
</p>
<p>
See
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl\">
Buildings.Examples.ChillerPlant.DataCenterContinuousTimeControl</a>
for an implementation with the discrete time trim and respond logic.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 13, 2015, by Michael Wetter:<br/>
Moved base model to
<a href=\"modelica://Buildings.Examples.ChillerPlant.BaseClasses.DataCenter\">
Buildings.Examples.ChillerPlant.BaseClasses.DataCenter</a>.
</li>
<li>
December 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,-300},{400,
              300}})),
      experiment(
        StopTime=86400,
        Tolerance=1e-06,
        __Dymola_Algorithm="Dassl"));
  end DataCenterContinuousTimeControlBypassContinuos;
end Validation;
