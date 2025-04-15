package DiscretizedHX_MSL
  model CorrectedHX "Simulation for the heat exchanger model"

    
    
  extends .Modelica.Icons.Example;

  parameter Integer n_cvs = 5 "number of control volumes";

  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  replaceable package Medium = .Modelica.Media.Water.StandardWaterOnePhase;
  //package Medium = Modelica.Media.Incompressible.Examples.Essotherm650;
    .DiscretizedHX_MSL.Components.BasicHX                                                   HEX(
      c_wall=500,
      use_T_start=true,
      nNodes=n_cvs,
      m_flow_start_2=0.2,
      k_wall=100,
      s_wall=0.005,
      crossArea_1=4.5e-4,
      crossArea_2=4.5e-4,
      perimeter_1=0.075,
      perimeter_2=0.075,
      rho_wall=900,
      redeclare package Medium_1 =
          Medium,
      redeclare package Medium_2 =
          Medium,
      modelStructure_1=.Modelica.Fluid.Types.ModelStructure.av_b,
      modelStructure_2=.Modelica.Fluid.Types.ModelStructure.a_vb,redeclare replaceable model HeatTransfer_1 = .DiscretizedHX_MSL.Components.ConstantFlowHeatTransfer_w_corr,
      length=20,
      area_h_1=0.075*20,
      area_h_2=0.075*20,redeclare replaceable model HeatTransfer_2 = .DiscretizedHX_MSL.Components.ConstantFlowHeatTransfer_w_corr,
      Twall_start=300,
      dT=10,redeclare replaceable model FlowModel_1 = .Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow(dp_nominal = 1000,m_flow_nominal = 1),redeclare replaceable model FlowModel_2 = .Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow(dp_nominal = 1000,m_flow_nominal = 1))         annotation (Placement(transformation(extent={{
              -26,-14},{34,46}})));

    .Modelica.Fluid.Sources.Boundary_pT ambient2(nPorts=1,
      p=1e5,
      T=280,
      redeclare package Medium = Medium) annotation (Placement(
          transformation(extent={{112.0,-26.0},{92.0,-6.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Fluid.Sources.Boundary_pT ambient1(nPorts=1,
      p=1e5,
      T=300,
      redeclare package Medium = Medium) annotation (Placement(
          transformation(extent={{110.0,20.0},{90.0,40.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Fluid.Sources.MassFlowSource_T massFlowRate2(nPorts=1,
      m_flow=0.2,
      T=360,
      redeclare package Medium = Medium,
      use_m_flow_in=true,
      use_T_in=false,
      use_X_in=false)
                  annotation (Placement(transformation(extent={{-87.0,29.0},{-67.0,49.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Fluid.Sources.MassFlowSource_T massFlowRate1(nPorts=1,
      redeclare package Medium = Medium,
      m_flow=0.2,
      T=313.15)
             annotation (Placement(transformation(extent={{-94.0,-28.0},{-74.0,-8.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.Ramp Ramp1(
      startTime=50,
      duration=5,
      height=0,
      offset=-0.25)
                   annotation (Placement(transformation(extent={{-125.0,35.0},{-105.0,55.0}},rotation = 0.0,origin = {0.0,0.0})));
    inner .Modelica.Fluid.System system(energyDynamics=.Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
        use_eps_Re=true) annotation (Placement(transformation(extent=
              {{60,70},{80,90}})));
        .Modelica.Fluid.Sensors.TemperatureTwoPort temperature_PrimIn(redeclare replaceable package Medium = Medium) annotation(Placement(transformation(extent = {{-66.0,-28.0},{-46.0,-8.0}},origin = {0.0,0.0},rotation = 0.0)));
        .Modelica.Fluid.Sensors.TemperatureTwoPort temperature_SecIn(redeclare replaceable package Medium = Medium) annotation(Placement(transformation(extent = {{72.0,-26.0},{52.0,-6.0}},origin = {0.0,0.0},rotation = 0.0)));
        .Modelica.Fluid.Sensors.TemperatureTwoPort temperature_PrimOut(redeclare replaceable package Medium = Medium) annotation(Placement(transformation(extent = {{54.0,20.0},{74.0,40.0}},origin = {0.0,0.0},rotation = 0.0)));
        .Modelica.Fluid.Sensors.TemperatureTwoPort temperature_SecOut(redeclare replaceable package Medium = Medium) annotation(Placement(transformation(extent = {{-40.0,20.0},{-60.0,40.0}},origin = {0.0,0.0},rotation = 0.0)));
  equation
    connect(Ramp1.y, massFlowRate2.m_flow_in) annotation (Line(points={{-104,45},{-104,47},{-87,47}}, color={0,0,127}));
        connect(massFlowRate1.ports[1],temperature_PrimIn.port_a) annotation(Line(points = {{-74,-18},{-66,-18}},color = {0,127,255}));
        connect(temperature_PrimIn.port_b,HEX.port_a1) annotation(Line(points = {{-46,-18},{-37.5,-18},{-37.5,15.4},{-29,15.4}},color = {0,127,255}));
        connect(HEX.port_b2,temperature_SecOut.port_a) annotation(Line(points = {{-29,29.8},{-34.5,29.8},{-34.5,30},{-40,30}},color = {0,127,255}));
        connect(temperature_SecOut.port_b,massFlowRate2.ports[1]) annotation(Line(points = {{-60,30},{-63.5,30},{-63.5,39},{-67,39}},color = {0,127,255}));
        connect(HEX.port_b1,temperature_PrimOut.port_a) annotation(Line(points = {{37,15.4},{45.5,15.4},{45.5,30},{54,30}},color = {0,127,255}));
        connect(temperature_PrimOut.port_b,ambient1.ports[1]) annotation(Line(points = {{74,30},{90,30}},color = {0,127,255}));
        connect(temperature_SecIn.port_a,ambient2.ports[1]) annotation(Line(points = {{72,-16},{92,-16}},color = {0,127,255}));
        connect(temperature_SecIn.port_b,HEX.port_a2) annotation(Line(points = {{52,-16},{44.5,-16},{44.5,2.1999999999999993},{37,2.1999999999999993}},color = {0,127,255}));
    annotation (experiment(
        StopTime=1000,
        Tolerance=0.000001,
        __Dymola_Algorithm=Cvode,StartTime = 0,Interval = 0,__Dymola_NumberOfIntervals = 500,__Dymola_fixedstepsize = 0.01),
      Documentation(info="<html>
<p>The simulation start in steady state with counterflow operation. At time t = 50, the mass flow rate on the secondary circuit is changed to a negative value in 5 seconds. After a transient, the heat exchanger operates in co-current flow.</p>
<p><img src=\"modelica://Modelica/Resources/Images/Fluid/Examples/HeatExchanger/HeatExchanger.png\" alt=\"HeatExchanger.png\"/></p>
</html>"));
    

  
  end CorrectedHX;

  model StandardHX "Simulation for the heat exchanger model"

  extends .Modelica.Icons.Example;

  parameter Integer n_cvs = 5 "number of control volumes";

  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  replaceable package Medium = .Modelica.Media.Water.StandardWaterOnePhase;
  //package Medium = Modelica.Media.Incompressible.Examples.Essotherm650;
    Modelica.Fluid.Examples.HeatExchanger.BaseClasses.BasicHX                                                   HEX(
      c_wall=500,
      use_T_start=true,
      nNodes=n_cvs,
      m_flow_start_2=0.2,
      k_wall=100,
      s_wall=0.005,
      crossArea_1=4.5e-4,
      crossArea_2=4.5e-4,
      perimeter_1=0.075,
      perimeter_2=0.075,
      rho_wall=900,
      redeclare package Medium_1 =
          Medium,
      redeclare package Medium_2 =
          Medium,
      modelStructure_1=.Modelica.Fluid.Types.ModelStructure.av_b,
      modelStructure_2=.Modelica.Fluid.Types.ModelStructure.a_vb,redeclare replaceable model HeatTransfer_1 = .DiscretizedHX_MSL.Components.ConstantFlowHeatTransfer_wo_corr,
      length=20,
      area_h_1=0.075*20,
      area_h_2=0.075*20,redeclare replaceable model HeatTransfer_2 = .DiscretizedHX_MSL.Components.ConstantFlowHeatTransfer_wo_corr,
      Twall_start=300,
      dT=10,redeclare replaceable model FlowModel_1 = .Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow(dp_nominal = 1000,m_flow_nominal = 1),redeclare replaceable model FlowModel_2 = .Modelica.Fluid.Pipes.BaseClasses.FlowModels.NominalLaminarFlow(dp_nominal = 1000,m_flow_nominal = 1))         annotation (Placement(transformation(extent={{
              -26,-14},{34,46}})));

    .Modelica.Fluid.Sources.Boundary_pT ambient2(nPorts=1,
      p=1e5,
      T=280,
      redeclare package Medium = Medium) annotation (Placement(
          transformation(extent={{112.0,-26.0},{92.0,-6.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Fluid.Sources.Boundary_pT ambient1(nPorts=1,
      p=1e5,
      T=300,
      redeclare package Medium = Medium) annotation (Placement(
          transformation(extent={{110.0,20.0},{90.0,40.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Fluid.Sources.MassFlowSource_T massFlowRate2(nPorts=1,
      m_flow=0.2,
      T=360,
      redeclare package Medium = Medium,
      use_m_flow_in=true,
      use_T_in=false,
      use_X_in=false)
                  annotation (Placement(transformation(extent={{-87.0,29.0},{-67.0,49.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Fluid.Sources.MassFlowSource_T massFlowRate1(nPorts=1,
      redeclare package Medium = Medium,
      m_flow=0.2,
      T=313.15)
             annotation (Placement(transformation(extent={{-94.0,-28.0},{-74.0,-8.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Sources.Ramp Ramp1(
      startTime=50,
      duration=5,
      height=0,
      offset=-0.25)
                   annotation (Placement(transformation(extent={{-125.0,35.0},{-105.0,55.0}},rotation = 0.0,origin = {0.0,0.0})));
    inner .Modelica.Fluid.System system(energyDynamics=.Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
        use_eps_Re=true) annotation (Placement(transformation(extent=
              {{60,70},{80,90}})));
        .Modelica.Fluid.Sensors.TemperatureTwoPort temperature_PrimIn(redeclare replaceable package Medium = Medium) annotation(Placement(transformation(extent = {{-66.0,-28.0},{-46.0,-8.0}},origin = {0.0,0.0},rotation = 0.0)));
        .Modelica.Fluid.Sensors.TemperatureTwoPort temperature_SecIn(redeclare replaceable package Medium = Medium) annotation(Placement(transformation(extent = {{72.0,-26.0},{52.0,-6.0}},origin = {0.0,0.0},rotation = 0.0)));
        .Modelica.Fluid.Sensors.TemperatureTwoPort temperature_PrimOut(redeclare replaceable package Medium = Medium) annotation(Placement(transformation(extent = {{54.0,20.0},{74.0,40.0}},origin = {0.0,0.0},rotation = 0.0)));
        .Modelica.Fluid.Sensors.TemperatureTwoPort temperature_SecOut(redeclare replaceable package Medium = Medium) annotation(Placement(transformation(extent = {{-40.0,20.0},{-60.0,40.0}},origin = {0.0,0.0},rotation = 0.0)));
  equation
    connect(Ramp1.y, massFlowRate2.m_flow_in) annotation (Line(points={{-104,45},{-104,47},{-87,47}}, color={0,0,127}));
        connect(massFlowRate1.ports[1],temperature_PrimIn.port_a) annotation(Line(points = {{-74,-18},{-66,-18}},color = {0,127,255}));
        connect(temperature_PrimIn.port_b,HEX.port_a1) annotation(Line(points = {{-46,-18},{-37.5,-18},{-37.5,15.4},{-29,15.4}},color = {0,127,255}));
        connect(HEX.port_b2,temperature_SecOut.port_a) annotation(Line(points = {{-29,29.8},{-34.5,29.8},{-34.5,30},{-40,30}},color = {0,127,255}));
        connect(temperature_SecOut.port_b,massFlowRate2.ports[1]) annotation(Line(points = {{-60,30},{-63.5,30},{-63.5,39},{-67,39}},color = {0,127,255}));
        connect(HEX.port_b1,temperature_PrimOut.port_a) annotation(Line(points = {{37,15.4},{45.5,15.4},{45.5,30},{54,30}},color = {0,127,255}));
        connect(temperature_PrimOut.port_b,ambient1.ports[1]) annotation(Line(points = {{74,30},{90,30}},color = {0,127,255}));
        connect(temperature_SecIn.port_a,ambient2.ports[1]) annotation(Line(points = {{72,-16},{92,-16}},color = {0,127,255}));
        connect(temperature_SecIn.port_b,HEX.port_a2) annotation(Line(points = {{52,-16},{44.5,-16},{44.5,2.1999999999999993},{37,2.1999999999999993}},color = {0,127,255}));
    annotation (experiment(
        StopTime=1000,
        Tolerance=0.0001,
        __Dymola_Algorithm=Cvode,StartTime = 0,Interval = 0,__Dymola_NumberOfIntervals = 500,__Dymola_fixedstepsize = 0.01),
      Documentation(info="<html>
<p>The simulation start in steady state with counterflow operation. At time t = 50, the mass flow rate on the secondary circuit is changed to a negative value in 5 seconds. After a transient, the heat exchanger operates in co-current flow.</p>
<p><img src=\"modelica://Modelica/Resources/Images/Fluid/Examples/HeatExchanger/HeatExchanger.png\" alt=\"HeatExchanger.png\"/></p>
</html>"));
  end StandardHX;
    package Components
        extends .Modelica.Icons.Package;

  model ConstantFlowHeatTransfer_wo_corr
    "ConstantHeatTransfer: Constant heat transfer coefficient"
    extends .Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.PartialFlowHeatTransfer;
    parameter .Modelica.Units.SI.CoefficientOfHeatTransfer alpha0=2000
      "Heat transfer coefficient";

  equation
    Q_flows = {alpha0*surfaceAreas[i]*(heatPorts[i].T - Ts[i])*nParallel for i in 1:n};
  //  corr_fac = 1;
    annotation(Documentation(info="<html>
<p>
Simple heat transfer correlation with constant heat transfer coefficient, used as default component in distributed pipe models.
</p>
</html>"));
  end ConstantFlowHeatTransfer_wo_corr;

  model ConstantFlowHeatTransfer_w_corr
    "ConstantHeatTransfer: Constant heat transfer coefficient"
    extends .Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.PartialFlowHeatTransfer;
    parameter .Modelica.Units.SI.CoefficientOfHeatTransfer alpha0=2000
      "Heat transfer coefficient";
    input Real corr_fac
      "used to control to steady state duty";
  equation
    Q_flows = {corr_fac * alpha0*surfaceAreas[i]*(heatPorts[i].T - Ts[i])*nParallel for i in 1:n};
  //  corr_fac = 1;
    annotation(Documentation(info="<html>
<p>
Simple heat transfer correlation with constant heat transfer coefficient, used as default component in distributed pipe models.
</p>
</html>"));
  end ConstantFlowHeatTransfer_w_corr;

  model BasicHX "Simple heat exchanger model"
    outer .Modelica.Fluid.System system "System properties";
    //General
    parameter .Modelica.Units.SI.Length length(min=0)
      "Length of flow path for both fluids";
    parameter Integer nNodes(min=1) = 2 "Spatial segmentation";
    parameter .Modelica.Fluid.Types.ModelStructure modelStructure_1=.Modelica.Fluid.Types.ModelStructure.av_vb
      "Determines whether flow or volume models are present at the ports"
      annotation(Evaluate=true, Dialog(tab="General",group="Fluid 1"));
    parameter .Modelica.Fluid.Types.ModelStructure modelStructure_2=.Modelica.Fluid.Types.ModelStructure.av_vb
      "Determines whether flow or volume models are present at the ports"
      annotation(Evaluate=true, Dialog(tab="General",group="Fluid 2"));
    replaceable package Medium_1 = .Modelica.Media.Water.StandardWater constrainedby
      .Modelica.Media.Interfaces.PartialMedium "Fluid 1"
                                                      annotation(choicesAllMatching, Dialog(tab="General",group="Fluid 1"));
    replaceable package Medium_2 = .Modelica.Media.Water.StandardWater constrainedby
      .Modelica.Media.Interfaces.PartialMedium "Fluid 2"
                                                      annotation(choicesAllMatching,Dialog(tab="General", group="Fluid 2"));
    parameter .Modelica.Units.SI.Area crossArea_1 "Cross sectional area"
      annotation (Dialog(tab="General", group="Fluid 1"));
    parameter .Modelica.Units.SI.Area crossArea_2 "Cross sectional area"
      annotation (Dialog(tab="General", group="Fluid 2"));
    parameter .Modelica.Units.SI.Length perimeter_1 "Flow channel perimeter"
      annotation (Dialog(tab="General", group="Fluid 1"));
    parameter .Modelica.Units.SI.Length perimeter_2 "Flow channel perimeter"
      annotation (Dialog(tab="General", group="Fluid 2"));
    final parameter Boolean use_HeatTransfer = true
      "= true to use the HeatTransfer_1/_2 model";

    // Heat transfer
    replaceable model HeatTransfer_1 =
        .Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer
      constrainedby
      .Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.PartialFlowHeatTransfer
      "Heat transfer model" annotation(choicesAllMatching, Dialog(tab="General", group="Fluid 1", enable=use_HeatTransfer));

    replaceable model HeatTransfer_2 =
        .Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.IdealFlowHeatTransfer
      constrainedby
      .Modelica.Fluid.Pipes.BaseClasses.HeatTransfer.PartialFlowHeatTransfer
      "Heat transfer model" annotation(choicesAllMatching, Dialog(tab="General", group="Fluid 2", enable=use_HeatTransfer));

    parameter .Modelica.Units.SI.Area area_h_1 "Heat transfer area"
      annotation (Dialog(tab="General", group="Fluid 1"));
    parameter .Modelica.Units.SI.Area area_h_2 "Heat transfer area"
      annotation (Dialog(tab="General", group="Fluid 2"));
   //Wall
    parameter .Modelica.Units.SI.Length s_wall(min=0) "Wall thickness"
      annotation (Dialog(group="Wall properties"));
    parameter .Modelica.Units.SI.ThermalConductivity k_wall
      "Thermal conductivity of wall material"
      annotation (Dialog(group="Wall properties"));
    parameter .Modelica.Units.SI.SpecificHeatCapacity c_wall
      "Specific heat capacity of wall material"
      annotation (Dialog(tab="General", group="Wall properties"));
    parameter .Modelica.Units.SI.Density rho_wall "Density of wall material"
      annotation (Dialog(tab="General", group="Wall properties"));
    final parameter .Modelica.Units.SI.Area area_h=(area_h_1 + area_h_2)/2
      "Heat transfer area";
    final parameter .Modelica.Units.SI.Mass m_wall=rho_wall*area_h*s_wall
      "Wall mass";

    // Assumptions
    parameter Boolean allowFlowReversal = system.allowFlowReversal
      "Allow flow reversal, false restricts to design direction (port_a -> port_b)"
      annotation(Dialog(tab="Assumptions"), Evaluate=true);
    parameter .Modelica.Fluid.Types.Dynamics energyDynamics=system.energyDynamics
      "Formulation of energy balance"
      annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
    parameter .Modelica.Fluid.Types.Dynamics massDynamics=system.massDynamics
      "Formulation of mass balance"
      annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
    parameter .Modelica.Fluid.Types.Dynamics momentumDynamics=system.momentumDynamics
      "Formulation of momentum balance, if pressureLoss options available"
      annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

    //Initialization pipe 1
    parameter .Modelica.Units.SI.Temperature Twall_start
      "Start value of wall temperature"
      annotation (Dialog(tab="Initialization", group="Wall"));
    parameter .Modelica.Units.SI.TemperatureDifference dT
      "Start value for pipe_1.T - pipe_2.T"
      annotation (Dialog(tab="Initialization", group="Wall"));
    parameter Boolean use_T_start=true
      "Use T_start if true, otherwise h_start"
      annotation(Evaluate=true, Dialog(tab = "Initialization"));
    parameter Medium_1.AbsolutePressure p_a_start1=Medium_1.p_default
      "Start value of pressure"
      annotation(Dialog(tab = "Initialization", group = "Fluid 1"));
    parameter Medium_1.AbsolutePressure p_b_start1=Medium_1.p_default
      "Start value of pressure"
      annotation(Dialog(tab = "Initialization", group = "Fluid 1"));
    parameter Medium_1.Temperature T_start_1=if use_T_start then Medium_1.
        T_default else Medium_1.temperature_phX(
          (p_a_start1 + p_b_start1)/2,
          h_start_1,
          X_start_1) "Start value of temperature"
      annotation(Evaluate=true, Dialog(tab = "Initialization", group = "Fluid 1", enable = use_T_start));
    parameter Medium_1.SpecificEnthalpy h_start_1=if use_T_start then Medium_1.specificEnthalpy_pTX(
          (p_a_start1 + p_b_start1)/2,
          T_start_1,
          X_start_1) else Medium_1.h_default
      "Start value of specific enthalpy"
      annotation(Evaluate=true, Dialog(tab = "Initialization", group = "Fluid 1", enable = not use_T_start));
    parameter Medium_1.MassFraction X_start_1[Medium_1.nX]=Medium_1.X_default
      "Start value of mass fractions m_i/m"
      annotation (Dialog(tab="Initialization", group = "Fluid 1", enable=(Medium_1.nXi > 0)));
    parameter Medium_1.MassFlowRate m_flow_start_1 = system.m_flow_start
      "Start value of mass flow rate" annotation(Evaluate=true, Dialog(tab = "Initialization", group = "Fluid 1"));
    //Initialization pipe 2

    parameter Medium_2.AbsolutePressure p_a_start2=Medium_2.p_default
      "Start value of pressure"
      annotation(Dialog(tab = "Initialization", group = "Fluid 2"));
    parameter Medium_2.AbsolutePressure p_b_start2=Medium_2.p_default
      "Start value of pressure"
      annotation(Dialog(tab = "Initialization", group = "Fluid 2"));
    parameter Medium_2.Temperature T_start_2=if use_T_start then Medium_2.
        T_default else Medium_2.temperature_phX(
          (p_a_start2 + p_b_start2)/2,
          h_start_2,
          X_start_2) "Start value of temperature"
      annotation(Evaluate=true, Dialog(tab = "Initialization", group = "Fluid 2", enable = use_T_start));
    parameter Medium_2.SpecificEnthalpy h_start_2=if use_T_start then Medium_2.specificEnthalpy_pTX(
          (p_a_start2 + p_b_start2)/2,
          T_start_2,
          X_start_2) else Medium_2.h_default
      "Start value of specific enthalpy"
      annotation(Evaluate=true, Dialog(tab = "Initialization", group = "Fluid 2", enable = not use_T_start));
    parameter Medium_2.MassFraction X_start_2[Medium_2.nX]=Medium_2.X_default
      "Start value of mass fractions m_i/m"
      annotation (Dialog(tab="Initialization", group = "Fluid 2", enable=Medium_2.nXi>0));
    parameter Medium_2.MassFlowRate m_flow_start_2 = system.m_flow_start
      "Start value of mass flow rate" annotation(Evaluate=true, Dialog(tab = "Initialization", group = "Fluid 2"));

    //Pressure drop and heat transfer
    replaceable model FlowModel_1 =
        .Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow
      constrainedby
      .Modelica.Fluid.Pipes.BaseClasses.FlowModels.PartialStaggeredFlowModel
      "Characteristic of wall friction" annotation(choicesAllMatching, Dialog(tab="General", group="Fluid 1"));
    replaceable model FlowModel_2 =
        .Modelica.Fluid.Pipes.BaseClasses.FlowModels.DetailedPipeFlow
      constrainedby
      .Modelica.Fluid.Pipes.BaseClasses.FlowModels.PartialStaggeredFlowModel
      "Characteristic of wall friction" annotation(choicesAllMatching, Dialog(tab="General", group="Fluid 2"));
    parameter .Modelica.Fluid.Types.Roughness roughness_1=2.5e-5
      "Absolute roughness of pipe (default = smooth steel pipe)" annotation(Dialog(tab="General", group="Fluid 1"));
    parameter .Modelica.Fluid.Types.Roughness roughness_2=2.5e-5
      "Absolute roughness of pipe (default = smooth steel pipe)" annotation(Dialog(tab="General", group="Fluid 2"));

    .Modelica.Units.SI.TemperatureDifference lmtd(start = 30);

    .Modelica.Units.SI.SpecificHeatCapacity c_p_water;
    .Modelica.Units.SI.HeatFlowRate ideal_exchanger_duty(start=1.2e4);
    .Modelica.Units.SI.Temperature hot_side_t_out(start=311);
    .Modelica.Units.SI.Temperature cold_side_t_out(start=281);
    .Modelica.Units.SI.CoefficientOfHeatTransfer U_overall(start = 25);

    //Display variables
    .Modelica.Units.SI.HeatFlowRate Q_flow_1 "Total heat flow rate of pipe 1";
    .Modelica.Units.SI.HeatFlowRate Q_flow_2 "Total heat flow rate of pipe 2";

   .Modelica.Fluid.Examples.HeatExchanger.BaseClasses.WallConstProps wall(
      rho_wall=rho_wall,
      c_wall=c_wall,
      T_start=Twall_start,
      k_wall=k_wall,
      dT=dT,
      s=s_wall,
      energyDynamics=energyDynamics,
      n=nNodes,
      area_h=area_h)
      annotation (Placement(transformation(extent={{-29,-23},{9,35}})));

    .Modelica.Fluid.Pipes.DynamicPipe pipe_1(
      redeclare final package Medium = Medium_1,
      final isCircular=false,
      final diameter=0,
      final nNodes=nNodes,
      final allowFlowReversal=allowFlowReversal,
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final momentumDynamics=momentumDynamics,
      final length=length,
      final use_HeatTransfer=use_HeatTransfer,
      redeclare replaceable model HeatTransfer =
          .DiscretizedHX_MSL.Components.ConstantFlowHeatTransfer_w_corr (corr_fac=PID.y),
      final use_T_start=use_T_start,
      final T_start=T_start_1,
      final h_start=h_start_1,
      final X_start=X_start_1,
      final m_flow_start=m_flow_start_1,
      final perimeter=perimeter_1,
      final crossArea=crossArea_1,
      final p_a_start=p_a_start1,
      final p_b_start=p_b_start1,
      final roughness=roughness_1,
      redeclare model FlowModel = FlowModel_1,
      final modelStructure=modelStructure_1,useLumpedPressure = true)
      annotation (Placement(transformation(extent={{-40.0,-80.0},{20.0,-20.0}},rotation = 0.0,origin = {0.0,0.0})));

    .Modelica.Fluid.Pipes.DynamicPipe pipe_2(
      redeclare final package Medium = Medium_2,
      final nNodes=nNodes,
      final allowFlowReversal=allowFlowReversal,
      final energyDynamics=energyDynamics,
      final massDynamics=massDynamics,
      final momentumDynamics=momentumDynamics,
      final length=length,
      final isCircular=false,
      final diameter=0,
      final use_HeatTransfer=use_HeatTransfer,
      redeclare replaceable model HeatTransfer =
          .DiscretizedHX_MSL.Components.ConstantFlowHeatTransfer_w_corr (corr_fac=PID.y),
      final use_T_start=use_T_start,
      final T_start=T_start_2,
      final h_start=h_start_2,
      final X_start=X_start_2,
      final m_flow_start=m_flow_start_2,
      final perimeter=perimeter_2,
      final crossArea=crossArea_2,
      final p_a_start=p_a_start2,
      final p_b_start=p_b_start2,
      final roughness=roughness_2,
      redeclare model FlowModel = FlowModel_2,
      final modelStructure=modelStructure_2)
      annotation (Placement(transformation(extent={{20.0,88.0},{-40.0,28.0}},rotation = 0.0,origin = {0.0,0.0})));

    .Modelica.Fluid.Interfaces.FluidPort_b port_b1(redeclare final package Medium =
          Medium_1) annotation (Placement(transformation(extent={{100,-12},{120,
              8}})));
    .Modelica.Fluid.Interfaces.FluidPort_a port_a1(redeclare final package Medium =
          Medium_1) annotation (Placement(transformation(extent={{-120,-12},{
              -100,8}})));
    .Modelica.Fluid.Interfaces.FluidPort_b port_b2(redeclare final package Medium =
          Medium_2) annotation (Placement(transformation(extent={{-120,36},{
              -100,56}})));
    .Modelica.Fluid.Interfaces.FluidPort_a port_a2(redeclare final package Medium =
          Medium_2) annotation (Placement(transformation(extent={{100,-56},{120,
              -36}})));

    .Modelica.Blocks.Sources.RealExpression film_coeff_correction(y=PID.y)
      annotation (Placement(transformation(extent={{-148.0,-30.0},{-128.0,-10.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Continuous.LimPID PID(controllerType=.Modelica.Blocks.Types.SimpleController.PI,
      k=0.0001,
      Ti=5,
      yMax=30,
      initType=.Modelica.Blocks.Types.Init.InitialState,
      y_start=1,
      homotopyType=.Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy)
      annotation (Placement(transformation(extent={{-172,-22},{-152,-2}})));
    .Modelica.Blocks.Sources.RealExpression temp_input(y=Q_flow_2)
      annotation (Placement(transformation(extent={{-254,-48},{-234,-28}})));
    .Modelica.Blocks.Sources.RealExpression duty_setpoint(y=ideal_exchanger_duty)
      annotation (Placement(transformation(extent={{-272,50},{-252,70}})));
    .Modelica.Blocks.Logical.Switch setpoint_active
      annotation (Placement(transformation(extent={{-220,28},{-200,48}})));
    .Modelica.Blocks.Sources.BooleanExpression controller_active(y=time > 50)
      annotation (Placement(transformation(extent={{-284.0,14.0},{-264.0,34.0}},rotation = 0.0,origin = {0.0,0.0})));
    .Modelica.Blocks.Logical.Switch feedback_active
      annotation (Placement(transformation(extent={{-188,-64},{-168,-44}})));
    .Modelica.Blocks.Sources.RealExpression zero(y=0)
      annotation (Placement(transformation(extent={{-276,-18},{-256,2}})));
  equation

    c_p_water = Medium_1.specificHeatCapacityCp(pipe_2.flowModel.states[1]);
    
    
    ideal_exchanger_duty = pipe_1.port_a.m_flow * c_p_water * (pipe_1.state_a.T - hot_side_t_out);
    ideal_exchanger_duty = pipe_2.port_a.m_flow * c_p_water * (cold_side_t_out - pipe_2.state_a.T);
    ideal_exchanger_duty = U_overall * wall.area_h * lmtd;
    
    1/ U_overall = 1/(pipe_2.heatTransfer.alpha0) + 1/ (pipe_1.heatTransfer.alpha0) + wall.s/wall.k_wall;
    
    
    lmtd = ((pipe_1.state_a.T - cold_side_t_out) - (hot_side_t_out - pipe_2.state_a.T)) / (.Modelica.Math.log(max((pipe_1.state_a.T - cold_side_t_out)/(hot_side_t_out - pipe_2.state_a.T), .Modelica.Constants.small)));

    Q_flow_1 = sum(pipe_1.heatTransfer.Q_flows);
    Q_flow_2 = sum(pipe_2.heatTransfer.Q_flows);
   // film_coeff_correction.y =  pipe_1.heatTransfer.corr_fac;
   // film_coeff_correction.y = pipe_2.heatTransfer.corr_fac;
    connect(pipe_2.port_b, port_b2) annotation (Line(
        points={{-40,58},{-76,58},{-76,46},{-110,46}},
        color={0,127,255},
        thickness=0.5));
    connect(pipe_1.port_b, port_b1) annotation (Line(
        points={{20,-50},{42,-50},{42,-2},{110,-2}},
        color={0,127,255},
        thickness=0.5));
    connect(pipe_1.port_a, port_a1) annotation (Line(
        points={{-40,-50},{-75.3,-50},{-75.3,-2},{-110,-2}},
        color={0,127,255},
        thickness=0.5));
    connect(pipe_2.port_a, port_a2) annotation (Line(
        points={{20,58},{65,58},{65,-46},{110,-46}},
        color={0,127,255},
        thickness=0.5));
    connect(wall.heatPort_b, pipe_1.heatPorts) annotation (Line(
        points={{-10,-8.5},{-10,-36.8},{-9.7,-36.8}}, color={191,0,0}));
    connect(pipe_2.heatPorts[nNodes:-1:1], wall.heatPort_a[1:nNodes])
      annotation (Line(
        points={{-10.3,44.8},{-10.3,31.7},{-10,31.7},{-10,20.5}}, color={127,0,0}));
    connect(controller_active.y, setpoint_active.u2) annotation (Line(points={{-263,24},{-230,24},{-230,38},{-222,38}}, color={255,0,255}));
    connect(duty_setpoint.y, setpoint_active.u1) annotation (Line(points={{-251,
            60},{-230,60},{-230,46},{-222,46}}, color={0,0,127}));
    connect(setpoint_active.y, PID.u_s) annotation (Line(points={{-199,38},{-184,
            38},{-184,-12},{-174,-12}}, color={0,0,127}));
    connect(feedback_active.y, PID.u_m) annotation (Line(points={{-167,-54},{-162,
            -54},{-162,-24}}, color={0,0,127}));
    connect(temp_input.y, feedback_active.u1) annotation (Line(points={{-233,-38},
            {-200,-38},{-200,-46},{-190,-46}}, color={0,0,127}));
    connect(zero.y, setpoint_active.u3) annotation (Line(points={{-255,-8},{-230,
            -8},{-230,30},{-222,30}}, color={0,0,127}));
    connect(zero.y, feedback_active.u3) annotation (Line(points={{-255,-8},{-222,
            -8},{-222,-62},{-190,-62}}, color={0,0,127}));
    connect(controller_active.y, feedback_active.u2) annotation (Line(points={{-263,24},{-230,24},{-230,-6},{-220,-6},{-220,-54},{-190,-54}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics={
          Rectangle(
            extent={{-100,-26},{100,-30}},
            fillColor={95,95,95},
            fillPattern=FillPattern.Forward),
          Rectangle(
            extent={{-100,30},{100,26}},
            fillColor={95,95,95},
            fillPattern=FillPattern.Forward),
          Rectangle(
            extent={{-100,60},{100,30}},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,63,125}),
          Rectangle(
            extent={{-100,-30},{100,-60}},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,63,125}),
          Rectangle(
            extent={{-100,26},{100,-26}},
            fillPattern=FillPattern.HorizontalCylinder,
            fillColor={0,128,255}),
          Text(
            extent={{-150,110},{150,70}},
            textColor={0,0,255},
            textString="%name"),
          Line(
            points={{30,-85},{-60,-85}},
            color={0,128,255}),
          Polygon(
            points={{20,-70},{60,-85},{20,-100},{20,-70}},
            lineColor={0,128,255},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid),
          Line(
            points={{30,77},{-60,77}},
            color={0,128,255}),
          Polygon(
            points={{-50,92},{-90,77},{-50,62},{-50,92}},
            lineColor={0,128,255},
            fillColor={0,128,255},
            fillPattern=FillPattern.Solid)}),
      Documentation(info="<html>
<p>Simple model of a heat exchanger consisting of two pipes and one wall in between.
For both fluids geometry parameters, such as heat transfer area and cross section as well as heat transfer and pressure drop correlations may be chosen.
The flow scheme may be concurrent or counterflow, defined by the respective flow directions of the fluids entering the component.
The design flow direction with positive m_flow variables is counterflow.</p>
</html>"));
  end BasicHX;
    end Components;
    annotation(uses(Modelica(version = "4.0.0")));
end DiscretizedHX_MSL;
