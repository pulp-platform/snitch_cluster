// See README.md for license details.

ThisBuild / scalaVersion := "2.13.14"
ThisBuild / version := "0.1.0"
ThisBuild / organization := "be.kuleuven.esat.micas"

val chiselVersion = "6.4.0"

lazy val root = (project in file("."))
  .settings(
    name := "snax-accelerators",
    libraryDependencies ++= Seq(
      "org.chipsalliance" %% "chisel" % chiselVersion,
      "edu.berkeley.cs" %% "chiseltest" % "6.0.0" % "test"
    ),
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit",
      "-Ymacro-annotations",
      "-P:chiselplugin:genBundleElements"
    ),
    addCompilerPlugin(
      "org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full
    )
  )
