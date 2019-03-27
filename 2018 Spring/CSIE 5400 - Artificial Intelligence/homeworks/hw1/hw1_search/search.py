# search.py
# ---------
# Licensing Information:  You are free to use or extend these projects for
# educational purposes provided that (1) you do not distribute or publish
# solutions, (2) you retain this notice, and (3) you provide clear
# attribution to UC Berkeley, including a link to http://ai.berkeley.edu.
# 
# Attribution Information: The Pacman AI projects were developed at UC Berkeley.
# The core projects and autograders were primarily created by John DeNero
# (denero@cs.berkeley.edu) and Dan Klein (klein@cs.berkeley.edu).
# Student side autograding was added by Brad Miller, Nick Hay, and
# Pieter Abbeel (pabbeel@cs.berkeley.edu).


"""
In search.py, you will implement generic search algorithms which are called by
Pacman agents (in searchAgents.py).
"""

import util

class SearchProblem:
    """
    This class outlines the structure of a search problem, but doesn't implement
    any of the methods (in object-oriented terminology: an abstract class).

    You do not need to change anything in this class, ever.
    """

    def getStartState(self):
        """
        Returns the start state for the search problem.
        """
        util.raiseNotDefined()

    def isGoalState(self, state):
        """
          state: Search state

        Returns True if and only if the state is a valid goal state.
        """
        util.raiseNotDefined()

    def getSuccessors(self, state):
        """
          state: Search state

        For a given state, this should return a list of triples, (successor,
        action, stepCost), where 'successor' is a successor to the current
        state, 'action' is the action required to get there, and 'stepCost' is
        the incremental cost of expanding to that successor.
        """
        util.raiseNotDefined()

    def getCostOfActions(self, actions):
        """
         actions: A list of actions to take

        This method returns the total cost of a particular sequence of actions.
        The sequence must be composed of legal moves.
        """
        util.raiseNotDefined()


def tinyMazeSearch(problem):
    """
    Returns a sequence of moves that solves tinyMaze.  For any other maze, the
    sequence of moves will be incorrect, so only use this for tinyMaze.
    """
    from game import Directions
    s = Directions.SOUTH
    w = Directions.WEST
    return  [s, s, w, s, w, w, s, w]

def depthFirstSearch(problem):
    """
    Search the deepest nodes in the search tree first.

    Your search algorithm needs to return a list of actions that reaches the
    goal. Make sure to implement a graph search algorithm.

    To get started, you might want to try some of these simple commands to
    understand the search problem that is being passed in:

    print "Start:", problem.getStartState()
    print "Is the start a goal?", problem.isGoalState(problem.getStartState())
    print "Start's successors:", problem.getSuccessors(problem.getStartState())
    """
    "*** YOUR CODE HERE ***"
    stack, pathStack = util.Stack(), util.Stack()           # Initialize 'stack' and 'pathStack'
    stack.push(problem.getStartState())                     # Push the 'StartState' to the stack

    visited = []                                            # Visited states
    paths = []                                              # Paths to the GoalState

    curr = stack.pop()                                      # Pop the first state in the stack
    while problem.isGoalState(curr) is False:               # Each time entering the while-loop, check whether 'curr' is the GoalState or not?
        if curr not in visited:                             # If curr has not been visited
            visited += [curr]                               # Append curr to visited
            succs = problem.getSuccessors(curr)
            for succ, dir, cost in succs:                   # For each succ of succs
                stack.push(succ)                            # Push the succ to the stack
                pathStack.push(paths + [dir])               # Push the path to the succ to pathStack
        curr = stack.pop()                                  # Current state = stack.pop()
        paths = pathStack.pop()                             # The path to current state
    return paths
    util.raiseNotDefined()

def breadthFirstSearch(problem):
    """Search the shallowest nodes in the search tree first."""
    "*** YOUR CODE HERE ***"
    queue, pathQueue = util.Queue(), util.Queue()           # Initialize 'queue' and 'pathQueue'                     
    queue.push(problem.getStartState())                     # Push the 'StartState' to the queue

    visited = []                                            # Visited states
    paths = []                                              # Paths to the GoalState

    curr = queue.pop()                                      # Pop the first state in the queue
    while problem.isGoalState(curr) is False:               # Each time entering the while-loop, check whether 'curr' isGoalState
        if curr not in visited:                             # If curr has not been visited
            visited += [curr]                               # Append curr to visited
            succs = problem.getSuccessors(curr)
            for succ, dir, cost in succs:                   # For each succ of succs
                queue.push(succ)                            # Push the succ to the queue
                pathQueue.push(paths + [dir])               # Push the path to the succ to pathQueue
        curr = queue.pop()                                  # Current state = queue.pop()
        paths = pathQueue.pop()                             # The path to current state
    return paths
    util.raiseNotDefined()

def uniformCostSearch(problem):
    """Search the node of least total cost first."""
    "*** YOUR CODE HERE ***"
    PQ, pathPQ = util.PriorityQueue(), util.PriorityQueue() # Initialize 'PQ' and 'pathPQ'
    PQ.push(problem.getStartState(), 0)                     # Push the 'StartState' and 'priority 0' to the PQ

    visited = []                                            # Visited states
    paths = []                                              # Paths to the GoalState

    curr = PQ.pop()                                         # Pop the first state in the PQ
    while problem.isGoalState(curr) is False:               # Each time entering the while-loop, check whether 'curr' isGoalState
        if curr not in visited:                             # If curr has not been visited
            visited += [curr]                               # Append curr to visited
            succs = problem.getSuccessors(curr)
            for succ, dir, cost in succs:                   # For each succ of succs
                tmpPath = paths + [dir]                     # Get the temporary path
                tmpCost = problem.getCostOfActions(tmpPath) # Get the temporary cost
                PQ.push(succ, tmpCost)                      # Push the succ and the cost to the PQ
                pathPQ.push(tmpPath, tmpCost)               # Push the succ and the cost to the pathPQ
        curr = PQ.pop()                                     # Currenct state = PQ.pop()
        paths = pathPQ.pop()                                # The path to current state
    return paths
    util.raiseNotDefined()

def nullHeuristic(state, problem = None):
    """
    A heuristic function estimates the cost from the current state to the nearest
    goal in the provided SearchProblem.  This heuristic is trivial.
    """
    return 0

def aStarSearch(problem, heuristic = nullHeuristic):
    """Search the node that has the lowest combined cost and heuristic first."""
    "*** YOUR CODE HERE ***"
    PQ, pathPQ = util.PriorityQueue(), util.PriorityQueue() # Initialize 'PQ' and 'pathPQ'
    PQ.push(problem.getStartState(), 0)                     # Push the 'StartState' and 'priority 0' to the PQ

    visited = []                                            # Visited states
    paths = []                                              # Paths to the GoalState

    curr = PQ.pop()                                         # Pop the first state in the PQ
    while problem.isGoalState(curr) is False:               # Each time entering the while-loop, check whether 'curr' isGoalState
        if curr not in visited:                             # If curr has not been visited
            visited += [curr]                               # Append curr to visited
            succs = problem.getSuccessors(curr)
            for succ, dir, cost in succs:                   # For each succ of succs
                tmpPath = paths + [dir]                     # Get the temporary path
                tmpCost = problem.getCostOfActions(tmpPath) + heuristic(succ, problem)
                                                            # Get the temporary cost
                PQ.push(succ, tmpCost)                      # Push the succ and the cost to the PQ
                pathPQ.push(tmpPath, tmpCost)               # Push the succ and the cost to the pathPQ
        curr = PQ.pop()                                     # Currenct state = PQ.pop()
        paths = pathPQ.pop()                                # The path to current state
    return paths
    util.raiseNotDefined()


# Abbreviations
bfs = breadthFirstSearch
dfs = depthFirstSearch
astar = aStarSearch
ucs = uniformCostSearch
