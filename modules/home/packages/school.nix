#stuff for school like latex
{pkgs, pkgs-2505, ...}: 

{
  home.packages = with pkgs; [
    (python3.withPackages (ps: with ps; [
      matplotlib
      numpy
    ]))

    #from 25.05 until quarto is fixed (syntax-highlighting bug)
    (pkgs-2505.quarto.override {
      extraPythonPackages = ps: with ps; [numpy matplotlib];
    })

    pandoc 

    (texliveMedium.withPackages (ps: with ps; [
      framed 
      fvextra
      upquote
      lineno
    ]))
  ];
}
