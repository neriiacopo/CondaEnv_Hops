# App Setup  ----------------------------------------------------------------------------------------------------
from flask import Flask
import ghhops_server as hs

app = Flask(__name__)
hops: hs.HopsFlask = hs.Hops(app)

# Import Additional Libraries -----------------------------------------------------------------------------------

# Global Function -----------------------------------------------------------------------------------------------

# App Components ------------------------------------------------------------------------------------------------

@hops.component(
    "/getItem",
    inputs=[
        hs.HopsNumber("data as Item A","A", "number"),
        hs.HopsNumber("data as Item B","B", "number")
        ],
    outputs=[hs.HopsNumber("data as Item","C", "number")],
)

def getItem(a,b):
    return a + b



@hops.component(
    "/getList",
    inputs=[hs.HopsNumber("data as List","D", "number", hs.HopsParamAccess.LIST)],
    outputs=[
        hs.HopsString("data as List","D", "text", hs.HopsParamAccess.LIST),
        hs.HopsNumber("Sum","S", "number")
        ],
)

def getList(l):
    # Modify list at list level
    total = sum(l)

    # Modify list at list->item level
    new_list = []
    for index, item in enumerate(l):
        new_list.append(f'index {index} & item {item}')

    return new_list, total



@hops.component(
    "/getTree",
    inputs=[hs.HopsNumber("data as Tree","D", "number", hs.HopsParamAccess.TREE)],
    outputs=[
        hs.HopsString("data as Tree","D", "text", hs.HopsParamAccess.TREE),
        hs.HopsNumber("Averages","A", "number", hs.HopsParamAccess.TREE)
        ],
)

def getTree(tree):
    # Modify tree at branch->list level
    avgs = {}
    for branch in tree:
        avgs[branch] = []
        avg = lambda x : sum(x) / len(x)
        avgs[branch].append(avg(tree[branch]))


    # Modify tree at branch->list->items level
    new_tree = {}
    for branch in tree:
        new_tree[branch] = []
        for item in tree[branch]:
            new_tree[branch].append(f'path {branch} & item {item}')

    return new_tree, avgs


# Run App ------------------------------------------------------------------------------------------------------

if __name__ == "__main__":
    app.run(debug=True)