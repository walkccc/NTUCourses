# multiAgents.py
# --------------
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

from util import manhattanDistance
from game import Directions
import random, util

from game import Agent

class ReflexAgent(Agent):
    """
      A reflex agent chooses an action at each choice point by examining
      its alternatives via a gameState evaluation function.

      The code below is provided as a guide.  You are welcome to change
      it in any way you see fit, so long as you don't touch our method
      headers.
    """

    def getAction(self, gameState):
        """
        You do not need to change this method, but you're welcome to.

        getAction chooses among the best options according to the evaluation function.

        Just like in the previous project, getAction takes a GameState and returns
        some Directions.X for some X in the set {North, South, West, East, Stop}
        """
        # Collect legal actions and successor gameStates
        legalMoves = gameState.getLegalActions()

        # Choose one of the best actions
        scores = [self.evaluationFunction(gameState, action) for action in legalMoves]
        bestScore = max(scores)
        bestIndices = [index for index in range(len(scores)) if scores[index] == bestScore]
        chosenIndex = random.choice(bestIndices) # Pick randomly among the best

        "Add more of your code here if you want to"

        return legalMoves[chosenIndex]

    def evaluationFunction(self, currentGameState, action):
        """
        Design a better evaluation function here.

        The evaluation function takes in the current and proposed successor
        GameStates (Pacman.py) and returns a number, where higher numbers are better.

        The code below extracts some useful information from the gameState, like the
        remaining food (newFood) and Pacman position after moving (newPos).
        newScaredTimes holds the number of actions that each ghost will remain
        scared because of Pacman having eaten a power pellet.

        Print out these variables to see what you're getting, then combine them
        to create a masterful evaluation function.
        """
        # Useful information you can extract from a GameState (Pacman.py)
        successorGameState = currentGameState.generatePacmanSuccessor(action)
        newPos = successorGameState.getPacmanPosition()
        newFood = successorGameState.getFood()
        currFood = currentGameState.getFood()
        newGhostStates = successorGameState.getGhostStates()

        "*** YOUR CODE HERE ***"
        # Find the best minGhost
        minGhost = 99999999
        for ghost in newGhostStates:
            if manhattanDistance(newPos, ghost.getPosition()) < minGhost:
                minGhost = max(manhattanDistance(newPos, ghost.getPosition()), 0.1)
        ghostDist = -99 / minGhost

        # Find the beset minFood
        foodList = newFood.asList()
        minFood = 99999999
        if foodList != []:
            for food in foodList:
                if manhattanDistance(newPos, food) < minFood:
                    minFood = manhattanDistance(newPos, food)
        else:
            minFood = 0
        
        return ghostDist - minFood - (99 * len(foodList))

def scoreEvaluationFunction(currentGameState):
    """
      This default evaluation function just returns the score of the gameState.
      The score is the same one displayed in the Pacman GUI.

      This evaluation function is meant for use with adversarial search agents
      (not reflex agents).
    """
    return currentGameState.getScore()

class MultiAgentSearchAgent(Agent):
    """
      This class provides some common elements to all of your
      multi-agent searchers.  Any methods defined here will be available
      to the MinimaxPacmanAgent, AlphaBetaPacmanAgent & ExpectimaxPacmanAgent.

      You *do not* need to make any changes here, but you can if you want to
      add functionality to all your adversarial search agents.  Please do not
      remove anything, however.

      Note: this is an abstract class: one that should not be instantiated.  It's
      only partially specified, and designed to be extended.  Agent (game.py)
      is another abstract class.
    """

    def __init__(self, evalFn = 'scoreEvaluationFunction', depth = '2'):
        self.index = 0 # Pacman is always agent index 0
        self.evaluationFunction = util.lookup(evalFn, globals())
        self.depth = int(depth)

class MinimaxAgent(MultiAgentSearchAgent):
    """
      Your minimax agent (question 2)
    """

    def getAction(self, gameState):
        """
          Returns the minimax action from the current gameState using self.depth
          and self.evaluationFunction.

          Here are some method calls that might be useful when implementing minimax.

          gameState.getLegalActions(PLAYER):
            Returns a list of legal actions for an agent
            PLAYER=0 means Pacman, ghosts are >= 1

          gameState.generateSuccessor(PLAYER, action):
            Returns the successor game gameState after an agent takes an action

          gameState.getNumAgents():
            Returns the total number of agents in the game
        """
        "*** YOUR CODE HERE ***"
        def terminalTest(gameState, PLAYER, depth):
            if gameState.isWin() or gameState.isLose() or (PLAYER == gameState.getNumAgents() and depth == self.depth):
                return True
            return False

        def MINIMAX(gameState, PLAYER, depth):
            if terminalTest(gameState, PLAYER, depth):          # if TERMINAL-TEST(s), 
                return self.evaluationFunction(gameState)       #     return UTILITY(s)
            
            if PLAYER == gameState.getNumAgents():
                return MINIMAX(gameState, 0, depth + 1)

            actions = []
            for a in gameState.getLegalActions(PLAYER):
                actions.append(MINIMAX(gameState.generateSuccessor(PLAYER, a), PLAYER + 1, depth))    
            return max(actions) if PLAYER == 0 else min(actions)
            
        legalActions = gameState.getLegalActions(0)             # Legal actions of Pacman
        return max(legalActions, key = lambda a: MINIMAX(gameState.generateSuccessor(0, a), 1, 1))

class AlphaBetaAgent(MultiAgentSearchAgent):
    """
      Your minimax agent with alpha-beta pruning (question 3)
    """

    def getAction(self, gameState):
        """
          Returns the minimax action using self.depth and self.evaluationFunction
        """
        "*** YOUR CODE HERE ***"
        
        def terminalTest(gameState, PLAYER, depth):
            if gameState.isWin() or gameState.isLose() or depth >= self.depth:
                return True
            return False

        def AlphaBeta(gameState, PLAYER, depth, alpha, beta):
            if terminalTest(gameState, PLAYER, depth):
                return [self.evaluationFunction(gameState)]
            
            nextPLAYER = (PLAYER + 1) % gameState.getNumAgents()
            level = 1 if nextPLAYER == 0 else 0
            v = [-99999999] if PLAYER == 0 else [99999999]     # Initialize v

            for a in gameState.getLegalActions(PLAYER):
                newState = gameState.generateSuccessor(PLAYER, a)
                value = AlphaBeta(newState, nextPLAYER, depth + level, alpha, beta) + [a]
                if PLAYER == 0:
                    v = max(v, value)
                    if v[0] > beta:                            # Early return
                        return v
                    alpha = max(alpha, v[0])
                else:
                    v = min(v, value)
                    if v[0] < alpha:                           # Early return
                        return v
                    beta = min(beta, v[0])
            return v
            
        return AlphaBeta(gameState, 0, 0, -99999999, 99999999)[-1]

class ExpectimaxAgent(MultiAgentSearchAgent):
    """
      Your expectimax agent (question 4)
    """           

    def getAction(self, gameState):
        """
          Returns the expectimax action using self.depth and self.evaluationFunction

          All ghosts should be modeled as choosing uniformly at random from their
          legal actions.
        """
        "*** YOUR CODE HERE ***"
        def terminalTest(gameState, PLAYER, depth):
            if gameState.isWin() or gameState.isLose() or (PLAYER == gameState.getNumAgents() and depth == self.depth):
                return True
            return False

        def EXPECTIMAX(gameState, PLAYER, depth):
            if terminalTest(gameState, PLAYER, depth):          # if TERMINAL-TEST(s), 
                return self.evaluationFunction(gameState)       #     return UTILITY(s)

            if PLAYER == gameState.getNumAgents():
                return EXPECTIMAX(gameState, 0, depth + 1)

            actions = []
            for a in gameState.getLegalActions(PLAYER):
                actions.append(EXPECTIMAX(gameState.generateSuccessor(PLAYER, a), PLAYER + 1, depth))

            return max(actions) if PLAYER == 0 else sum(list(actions)) / len(list(actions))
            
        legalActions = gameState.getLegalActions(0)             # Legal actions of Pacman
        return max(legalActions, key = lambda a: EXPECTIMAX(gameState.generateSuccessor(0, a), 1, 1))

def betterEvaluationFunction(currentGameState):
    """
      Your extreme ghost-hunting, pellet-nabbing, food-gobbling, unstoppable
      evaluation function (question 5).

      DESCRIPTION: <write something here so we know what you did>
    """
    "*** YOUR CODE HERE ***"    

# Abbreviation
better = betterEvaluationFunction
