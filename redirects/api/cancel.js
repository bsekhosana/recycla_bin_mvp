module.exports = (req, res) => {
  res.writeHead(302, { Location: 'recyclabin://payment/cancel' });
  res.end();
};
