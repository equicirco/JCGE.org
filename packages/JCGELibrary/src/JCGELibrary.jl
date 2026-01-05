module JCGELibrary

"""
JCGELibrary: a collection of CGE model definitions (as submodules) built on top of the JCGE ecosystem.

Usage pattern:
  using JCGELibrary
  using JCGELibrary.StandardCGE

Each model submodule should provide a small, stable API (e.g., `model()` returning a spec/object).
"""

# Models live in ../models/*.jl
# Add includes here as models are added, e.g.:
# include("../models/StandardCGE.jl")
# export StandardCGE

end # module
