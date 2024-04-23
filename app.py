# App Setup  ----------------------------------------------------------------------------------------------------
from flask import Flask
import ghhops_server as hs

app = Flask(__name__)
hops: hs.HopsFlask = hs.Hops(app)

# Import Additional Libraries -----------------------------------------------------------------------------------

# Global Function -----------------------------------------------------------------------------------------------

def f_add(a,b) :
    return a + b

# App Components ------------------------------------------------------------------------------------------------

@hops.component(
    "/add",
    inputs=[hs.HopsNumber("A"), hs.HopsNumber("B")],
    outputs=[hs.HopsNumber("Sum")],
)

def add(a: float, b: float):
    return f_add(a,b)

# Run App ------------------------------------------------------------------------------------------------------

if __name__ == "__main__":
    app.run(debug=True)