using Microsoft.AspNetCore.Mvc;
using StackExchange.Redis;
using NReJSON;
using Newtonsoft.Json;

namespace redis.Controllers
{
  [ApiController]
  [Route("api/[controller]")]
  public class RedisController : ControllerBase
  {
    Baby _baby;

    private readonly IConnectionMultiplexer _connectionMultiplexer;
    private readonly IConfiguration _config;

    public RedisController(IConfiguration config)
    {
      Baby baby = new Baby()
      {
        FirstName = "Rob",
        LastName = "Azinger",
        Birthday = DateTime.Now,
        Weight = 7.7,
      };

      _baby = baby;
      _config = config;

      _connectionMultiplexer = ConnectionMultiplexer.Connect(_config["CacheConnection"]!.ToString());
    }

    [HttpGet]
    [Route("Baby/Check")]
    public IActionResult CheckBaby()
    {
      return Ok(_baby);
    }

    [HttpGet]
    [Route("Baby/Save")]
    public async Task<IActionResult> SaveBaby()
    {
      string json = JsonConvert.SerializeObject(_baby);
      string key = "baby:" + _baby.FirstName?.ToLower();

      IDatabase db = _connectionMultiplexer.GetDatabase();

      OperationResult result = await db.JsonSetAsync(key, json);

      if (result.IsSuccess)
      {
        return Ok("Baby save succeeded");
      }

      return BadRequest("Baby save failed");
    }

    [HttpGet]
    [Route("Baby/Read")]
    public async Task<IActionResult> ReadBaby()
    {
      string key = "baby:" + _baby.FirstName?.ToLower();
      string[] parms = { "." };

      IDatabase db = _connectionMultiplexer.GetDatabase();

      RedisResult result = await db.JsonGetAsync(key, parms);

      if (result.IsNull)
      {
        return BadRequest("Baby read failed");
      }

      string? baby = (string?)result;
      return Ok(baby);
    }
  }

  public class Baby
  {
    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public DateTime Birthday { get; set; }

    public double Weight { get; set; }
  }
}