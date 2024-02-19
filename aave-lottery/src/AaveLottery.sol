// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {IPool} from "aave-v3-core/contracts/interfaces/IPool.sol";
import {IAToken} from "aave-v3-core/contracts/interfaces/IAToken.sol";
import {DataTypes} from "aave-v3-core/contracts/protocol/libraries/types/DataTypes.sol";
import {WadRayMath} from "aave-v3-core/contracts/protocol/libraries/math/WadRayMath.sol";


// We supply 1000 DAI to AAVE pool -> We will get in return 1000 aDAI
// time flies
// We end up eith 1005 aDAI after interest grows.
// We can exchange the 1005 eDAI for 1005 DAI.


contract AaveLottery {
    using SafeERC20 for IERC20;
    using WadRayMath for uint256;
    
    struct Round {
        uint256 endTime;
        uint256 totalStake;
        uint256 prize;
        uint256 winningNumber;
        address winner;
        uint256 scaledBalanceStake;
    }

    struct Ticket {
        uint256 stake;
        uint256 segmentStart;
        bool exited;
    }

    uint256 public roundDuration; // seconds
    uint256 public currentRoundId;
    IERC20 public underlying; // asset

    IPool private aave;
    IAToken private aToken;

    // roundId => (userAddress => Ticket)
    mapping(uint256 => mapping(address => Ticket)) public tickets;

    // roundId => Round
    mapping(uint256 => Round) public rounds;

    constructor(uint256 _roundDuration, address _underlying, address _aavePool) {
        roundDuration = _roundDuration;
        underlying = IERC20(_underlying);
        aave = IPool(_aavePool);
        DataTypes.ReserveData memory data = aave.getReserveData(_underlying);
        require(data.aTokenAddress != address(0), "ATOKEN_DOESNT_EXIST");
        aToken = IAToken(data.aTokenAddress);

        underlying.approve(address(_aavePool), type(uint256).max);

        // Init the first round
        rounds[currentRoundId] = Round(
            block.timestamp + _roundDuration,
            0,
            0,
            0,
            address(0),
            0
        );
    }


    function getRound(uint256 roundId) external view returns(Round memory) {
        return rounds[roundId];
    }

    function getTicket(uint256 roundId, address user) external view returns(Ticket memory) {
        return tickets[roundId][user];
    }

    function enter(uint256 amount) external {
        // One user can only enter once
        require(tickets[currentRoundId][msg.sender].stake == 0, "USER_ALREADY_PARTICIPANT");
        _updateState();

        tickets[currentRoundId][msg.sender].segmentStart = rounds[currentRoundId].totalStake;
        tickets[currentRoundId][msg.sender].stake = amount;
        rounds[currentRoundId].totalStake += amount;

        // Transfer funds in - user must approve this contract
        underlying.safeTransferFrom(msg.sender, address(this), amount);

        // Deposit funds to Aave pool
        uint256 scaledBalanceStakedBefore = aToken.scaledBalanceOf(address(this));
        aave.deposit(address(underlying), amount, address(this), 0);
        uint256 scaledBalanceStakedAfter = aToken.scaledBalanceOf(address(this));
        rounds[currentRoundId].scaledBalanceStake += scaledBalanceStakedAfter - scaledBalanceStakedBefore;

    }

    function exit(uint256 roundId) external {
        require(tickets[roundId][msg.sender].exited == false, "ALREADY_EXITED");

        _updateState();

        // Use doesn't try to exit from the same round they entered.
        require(roundId < currentRoundId, "CURRENT_LOTTERY");
        
        // User exits
        uint256 amount = tickets[currentRoundId][msg.sender].stake;
        tickets[roundId][msg.sender].exited = true;
        rounds[roundId].totalStake -= amount;
        
        // Transfer funds out
        underlying.safeTransfer(msg.sender, amount);
    }
        

    function claim(uint256 roundId) external {
        // Only claim if round has finished
        require(roundId < currentRoundId, "CURRENT_LOTTERY");

        Ticket memory ticket = tickets[currentRoundId][msg.sender];
        Round memory round = rounds[roundId];

        // Check winner - round.winningNumber belongs to [ticket.segmentStart, ticket.segmentStart + ticket.stake)
        require(round.winningNumber - ticket.segmentStart < ticket.stake, "NOT_WINNER");
        require(round.winner == address(0), "ALREADY_CLAIMED"); // Check prize has not been claimed yet.
        round.winner = msg.sender;

        // Transfer funds out
        underlying.safeTransfer(msg.sender, round.prize);

    }

    function _drawWinner(uint256 total) internal view returns(uint256) {
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    rounds[currentRoundId].totalStake,
                    currentRoundId
                )
            )
        ); // [0, 2^256 -1)
        return random % total; // [0, total) We have also introduced a modulo bias here, but this is just fun.
    }
    // Alice stakes 100 tokens so she gets a range [0, 99]
    // Bob then stakes 50 tokens so he gets a range [100, 149]
    // If winning number is 80 -> Alice wins as 80 is in [0. 99]
    // So winning number cannot be > 149. Hence total = totalStake of the round.

    function _updateState() internal {
        if (block.timestamp > rounds[currentRoundId].endTime) {
            // Award - aave withdraw
            // scaledBalance * index = total amount of aTokens.
            uint256 index = aave.getReserveNormalizedIncome(address(underlying));
            uint256 aTokenBalance = rounds[currentRoundId].scaledBalanceStake.rayMul(index);
            uint256 aaveAmount = aave.withdraw(address(underlying), aTokenBalance, address(this)); // principal + interest

            rounds[currentRoundId].prize = aaveAmount - rounds[currentRoundId].totalStake;
            
            // Lottery draw
            rounds[currentRoundId].winningNumber = _drawWinner(rounds[currentRoundId].totalStake);

            // Create a new round
            ++currentRoundId;
            rounds[currentRoundId].endTime = block.timestamp + roundDuration;
        }
    }
}